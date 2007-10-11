# Teskal



class AdminController < ApplicationController
  layout 'base'	
  before_filter :require_admin

  helper :sort
  include SortHelper	

  def index	
  end
	
  def projects
    sort_init 'name', 'asc'
    sort_update
    
    @status = params[:status] ? params[:status].to_i : 0
    conditions = nil
    conditions = ["status=?", @status] unless @status == 0
    
    @project_count = Project.count(:conditions => conditions)
    @project_pages = Paginator.new self, @project_count,
								25,
								params['page']								
    @projects = Project.find :all, :order => sort_clause,
                        :conditions => conditions,
						:limit  =>  @project_pages.items_per_page,
						:offset =>  @project_pages.current.offset

    render :action => "projects", :layout => false if request.xhr?
  end

  def mail_options
    @actions = Permission.find(:all, :conditions => ["mail_option=?", true]) || []
    if request.post?
      @actions.each { |a|
        a.mail_enabled = (params[:action_ids] || []).include? a.id.to_s 
        a.save
      }
      flash.now[:notice] = l(:notice_successful_update)
    end
  end                                      
  
  def stats
    @users = User.count_by_sql "select count(*) from users"
    @quests = Answer.count_by_sql "select count(*) from answers"
  end
  
  def info
    @db_adapter_name = ActiveRecord::Base.connection.adapter_name
    @flags = Hash.new
    @flags[:default_admin_changed] = User.find(:first, :conditions => ["login=? and hashed_password=?", 'admin', User.hash_password('admin')]).nil?
    @flags[:textile_available] = ActionView::Helpers::TextHelper.method_defined? "textilize"
  end  
end
