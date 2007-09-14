# Teskal
# Copyright (C) 2007 Teskal


class UsersController < ApplicationController
  layout 'base'	
  before_filter :require_admin

  helper :sort
  include SortHelper

  def index
    list
    render :action => 'list' unless request.xhr?
  end

  def list
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

  def add
      @user = User.new(params[:user])
      @user.admin = params[:user][:admin] || false
      @user.login = params[:user][:login]
      @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] 

      if @user.save
        Mailer.deliver_account_information(@user, params[:password]) if params[:send_information]
        flash[:notice] = l(:notice_successful_create)
        redirect_to :action => 'list'
      end
    # end
  end

  def edit
    @user = User.find(params[:id])
    if request.get?

    else
      @user.admin = params[:user][:admin] if params[:user][:admin]
      @user.login = params[:user][:login] if params[:user][:login]
      @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] unless params[:password].nil? or params[:password].empty?
      if @user.update_attributes(params[:user])
        flash[:notice] = l(:notice_successful_update)
        redirect_to :action => 'list'
      end
    end

    @roles = Role.find(:all, :order => 'position')
    @projects = Project.find(:all, :order => 'name', :conditions => "status=#{Project::STATUS_ACTIVE}") - @user.projects
    @membership ||= Member.new
  end
  
  def edit_membership
    @user = User.find(params[:id])
    @membership = params[:membership_id] ? Member.find(params[:membership_id]) : Member.new(:user => @user)
    @membership.attributes = params[:membership]
    if request.post? and @membership.save
      flash[:notice] = l(:notice_successful_update)
    end
    redirect_to :action => 'edit', :id => @user and return
  end
  
  def destroy_membership
    @user = User.find(params[:id])
    if request.post? and Member.find(params[:membership_id]).destroy
      flash[:notice] = l(:notice_successful_update)
    end
    redirect_to :action => 'edit', :id => @user and return
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  rescue
    flash[:notice] = "Unable to delete user"
    redirect_to :action => 'list'
  end  
end
