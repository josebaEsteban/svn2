# Teskal
# Copyright (C) 2007 Teskal


class UsersController < ApplicationController
  layout 'base'
  before_filter :require_coach

  helper :sort
  include SortHelper

  def index
    if @logged_in_user.admin?
      list
      render :action => 'list' unless request.xhr?
    end
  end

  def list
    if @logged_in_user.admin?
      sort_init 'login', 'asc'
      sort_update

      @status = params[:status] ? params[:status].to_i : 1
      conditions = nil
      conditions = ["status=?", @status] unless @status == 0

      @user_count = User.count(:conditions => conditions)
      @user_pages = Paginator.new self, @user_count,
      15,
      params['page']
      @users =  User.find :all,:order => sort_clause,
      :conditions => conditions,
      :limit  =>  @user_pages.items_per_page,
      :offset =>  @user_pages.current.offset

      render :action => "list", :layout => false if request.xhr?
    end
  end

  def add
    if request.get?
      @user = User.new(:language => Setting.default_language)
    else
      @user = User.new(params[:user])
      @user.admin = params[:user][:admin] || false
      @user.login = params[:user][:login]
      @user.password, @user.password_confirmation = params[:password], params[:password_confirmation]
      ip = request.remote_ip
      @user.managed_by = session[:user_id]
      @user.role = User::ROLE_ATHLETE
      if @user.save
        Mailer.deliver_account_information(@user, params[:password])
        create_library(@user.id)
        # if params[:send_information]
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'my', :action => 'athletes'
        # redirect_to :action => 'list'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.managed_by != @logged_in_user.id
      flash.now[:notice] = l(:notice_not_authorized)
      redirect_to :controller => 'my', :action => 'athletes'
    end
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if  @user.save
      journal("update account",@user.id)
      flash.now[:notice] = l(:notice_account_updated)
    end
    redirect_to :controller => 'my', :action => 'athletes'
  end

  def edit_membership
    if @logged_in_user.admin?
      @user = User.find(params[:id])
      @membership = params[:membership_id] ? Member.find(params[:membership_id]) : Member.new(:user => @user)
      @membership.attributes = params[:membership]
      if request.post? and @membership.save
        flash[:notice] = l(:notice_successful_update)
      end
      redirect_to :action => 'edit', :id => @user and return
    end
  end

  def destroy_membership
    if @logged_in_user.admin?
      @user = User.find(params[:id])
      if request.post? and Member.find(params[:membership_id]).destroy
        flash[:notice] = l(:notice_successful_update)
      end
      redirect_to :action => 'edit', :id => @user and return
    end
  end

  # def destroy
  #   if @logged_in_user.admin?
  #     User.find(params[:id]).destroy
  #     redirect_to :action => 'list'
  #   rescue
  #     flash[:notice] = "Unable to delete user"
  #     redirect_to :action => 'list'
  #   end
  # end

  def switch
    user = User.find(params[:id])
    if  @logged_in_user.admin? or @logged_in_user.id == user.managed_by
      if user.status == 3
        user.status = 1
      else
        if user.status == 1
          user.status = 3
        end
      end
      user.save
      redirect_back_or_default :controller => 'my', :action => 'athletes'
    else
      redirect_back_or_default :controller => 'my', :action => 'page'
    end
  end

end
