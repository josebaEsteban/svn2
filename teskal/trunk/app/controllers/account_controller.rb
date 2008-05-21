# teskal  Copyright (C) 2007


class AccountController < ApplicationController
  layout 'base'

  # prevents login action to be filtered by check_if_login_required application scope filter
  skip_before_filter :check_if_login_required, :only => [:login, :lost_password, :signup, :terms, :activate]
  before_filter :require_login, :only => :logout

  # Show user's account
  def show
    @user = User.find(params[:id])

    # show only public projects and private projects that the logged in user is also a member of
    @memberships = @user.memberships.select do |membership|
      membership.project.is_public? || (logged_in_user && logged_in_user.role_for_project(membership.project))
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Login request and validation
  def login
    if request.get?
      # Logout user
      self.logged_in_user = nil
    else
      # Authenticate user
      user = User.try_to_login(params[:login], params[:password])
      puts user
      if user
        if user.locked?
          flash.now[:notice] = l(:user)+" "+l(:status_locked)
        else
          self.logged_in_user = user
          # user.update_attribute(:ip_last, request.remote_ip)
          journal("log_in",user.id)
          # generate a key and set cookie if autologin
          if params[:autologin] && Setting.autologin?
            token = Token.create(:user => user, :action => 'autologin')
            cookies[:autologin] = { :value => token.value, :expires => 1.year.from_now  }
          end
          if user.role > User::ROLE_ATHLETE
            redirect_to :controller => 'my', :action => 'athletes'
          else
            redirect_to :controller => 'my', :action => 'page'
          end
        end
      else
        flash.now[:notice] = l(:notice_account_invalid_creditentials)
        journal("invalid-"+params[:login]+"-"+params[:password],0)
      end
    end
  end

  # Log out current user and redirect to welcome page
  def logout
    journal("log_out",session[:user_id])
    cookies.delete :autologin
    Token.delete_all(["user_id = ? AND action = ?", logged_in_user.id, "autologin"]) if logged_in_user
    self.logged_in_user = nil
    redirect_to :controller => 'welcome'
    # redirect_to :action => 'login'
  end

  # Enable user to choose a new password
  def lost_password
    redirect_to :controller => 'welcome' and return unless Setting.lost_password?
    if params[:token]
      @token = Token.find_by_action_and_value("recovery", params[:token])
      redirect_to :controller => 'welcome' and return unless @token and !@token.expired?
      @user = @token.user
      if request.post?
        @user.password, @user.password_confirmation = params[:new_password], params[:new_password_confirmation]
        if @user.save
          journal("recovery pass",@user.id)
          @token.destroy
          flash[:notice] = l(:notice_account_password_updated)
          redirect_to :action => 'login'
          return
        end
      end
      render :template => "account/password_recovery"
      return
    else
      if request.post?
        user = User.find_by_mail(params[:mail])
        # user not found in db
        flash.now[:notice] = l(:notice_account_unknown_email) and return unless user
        # create a new token for password recovery
        token = Token.new(:user => user, :action => "recovery")
        if token.save
          Mailer.deliver_lost_password(token)
          journal("mailer-lost pass-"+user.mail,user.id)
          redirect_to :controller => 'welcome', :action => 'lost_email_sent'

          # flash[:notice] = l(:notice_account_lost_email_sent)
          # redirect_to :action => 'login'

          return
        end
      end
    end
  end

  # User self-registration
  def signup
    redirect_to :controller => 'welcome' and return unless Setting.self_registration?
    if params[:token]
      token = Token.find_by_action_and_value("signup", params[:token])
      redirect_to :controller => 'welcome' and return unless token and !token.expired?
      user = token.user
      redirect_to :controller => 'welcome' and return unless user.status == User::STATUS_REGISTERED
      user.status = User::STATUS_ACTIVE
      user.firstname = user.login
      if user.save
        journal("activate account", user.id)
        token.destroy
        flash[:notice] = l(:notice_account_activated)
        redirect_to :action => 'login'
        return
      end
    else
      if request.get?
        @user = User.new(:language => Setting.default_language)
      else
        dup_email = User.find_by_mail(params[:user][:mail])
        dup_login = User.find_by_login(params[:user][:login])
        if dup_email.nil? and dup_login.nil?
          @user = User.new(params[:user])
          @user.admin = false
          @user.login = params[:user][:login]
          @user.status = User::STATUS_REGISTERED
          @user.role = User::ROLE_GRATIS
          @user.password, @user.password_confirmation = params[:password], params[:password_confirmation]
          token = Token.new(:user => @user, :action => "signup")
          @user.ip = request.remote_ip
          if @user.save and token.save
            Mailer.deliver_signup(token)
            journal("mailer-signup",@user.id)
            set_language_if_valid(@user.language)
            create_library(@user.id)
            create_avail_quest(@user.id)
            # render :partial => "signup_done"
            # flash[:notice] = l(:notice_account_register_done)
            # redirect_to :controller => 'account', :action => 'login'
            redirect_to :controller => 'welcome', :action => 'signup_done'
          end
        else
          if dup_login.nil?
            flash[:notice] = l(:notice_account_email_exists)
            journal("failed_add_user/email_exists",0)
          else
            flash[:notice] = l(:notice_account_login_exists)
            journal("failed_add_user/login_exists",0)
          end
        end
      end
    end
  end

  # Token based account activation
  def activate
    redirect_to(home_url) && return unless Setting.self_registration? && params[:token]
    token = Token.find_by_action_and_value('signup', params[:token])
    redirect_to(home_url) && return unless token and !token.expired?
    user = token.user
    redirect_to(home_url) && return unless user.status == User::STATUS_REGISTERED
    user.status = User::STATUS_ACTIVE
    if user.save
      token.destroy
      flash[:notice] = l(:notice_account_activated)
    end
    redirect_to :action => 'login'
  end

  def terms
  end

end
