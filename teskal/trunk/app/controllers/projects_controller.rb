# Teskal
# Copyright (C) 2007 Teskal



class ProjectsController < ApplicationController
  layout 'base'
  before_filter :find_project, :except => [ :index, :list, :add ]
  before_filter :authorize, :except => [ :index, :list, :add, :archive, :unarchive, :destroy ]
  before_filter :require_admin, :only => [ :add, :archive, :unarchive, :destroy ]

  cache_sweeper :project_sweeper, :only => [ :add, :edit, :archive, :unarchive, :destroy ]


  helper :sort
  include SortHelper

  helper :ifpdf
  include IfpdfHelper


  def index
    list
    render :action => 'list' unless request.xhr?
  end

  # Lists public projects
  def list
    sort_init "#{Project.table_name}.name", "asc"
    sort_update
    @project_count = Project.count(:all, :conditions => Project.visible_by(logged_in_user))
    @project_pages = Paginator.new self, @project_count,
    15,
    params['page']
    @projects = Project.find :all, :order => sort_clause,
    :conditions => Project.visible_by(logged_in_user),
    :include => :parent,
    :limit  =>  @project_pages.items_per_page,
    :offset =>  @project_pages.current.offset

    render :action => "list", :layout => false if request.xhr?
  end

  # Add a new project
  def add
    @root_projects = Project.find(:all, :conditions => "parent_id is null")
    @project = Project.new(params[:project])
    if request.get?

    else
      if @project.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'admin', :action => 'projects'
      end
    end
  end

  # Show @project
  def show
    @members_by_role = @project.members.find(:all, :include => [:user, :role], :order => 'position').group_by {|m| m.role}
    @subprojects = @project.active_children
    @news = @project.news.find(:all, :limit => 5, :include => [ :author, :project ], :order => "#{News.table_name}.created_on DESC")
  end

  def settings
    @root_projects = Project::find(:all, :conditions => ["parent_id is null and id <> ?", @project.id])
    @issue_category ||= IssueCategory.new
    @member ||= @project.members.new
  end

  # Edit @project
  def edit
    if request.post?
    end
    @project.attributes = params[:project]
    if @project.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'settings', :id => @project
    else
      settings
      render :action => 'settings'
    end
  end

  def archive
    @project.archive if request.post? && @project.active?
    redirect_to :controller => 'admin', :action => 'projects'
  end

  def unarchive
    @project.unarchive if request.post? && !@project.active?
    redirect_to :controller => 'admin', :action => 'projects'
  end

  # Delete @project
  def destroy
    @project_to_destroy = @project
    if request.post? and params[:confirm]
      @project_to_destroy.destroy
      redirect_to :controller => 'admin', :action => 'projects'
    end
    # hide project in layout
    @project = nil
  end




  # Add a new member to @project
  def add_member
    @member = @project.members.build(params[:member])
    if request.post? && @member.save
      respond_to do |format|
        format.html { redirect_to :action => 'settings', :tab => 'members', :id => @project }
        format.js { render(:update) {|page| page.replace_html "tab-content-members", :partial => 'members'} }
      end
    else
      settings
      render :action => 'settings'
    end
  end

  # Show members list of @project
  def list_members
    @members = @project.members.find(:all)
  end






  # Export filtered/sorted issues to PDF
  def export_issues_pdf
    sort_init "#{Issue.table_name}.id", "desc"
    sort_update

    retrieve_query
    render :action => 'list_issues' and return unless @query.valid?

    @issues =  Issue.find :all, :order => sort_clause,
    :include => [ :author, :status, :tracker, :priority, :project],
    :conditions => @query.statement,
    :limit => Setting.issues_export_limit.to_i

    @options_for_rfpdf ||= {}
    @options_for_rfpdf[:file_name] = "export.pdf"
    render :layout => false
  end


  def activity
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end
    end
    @year ||= Date.today.year
    @month ||= Date.today.month

    @date_from = Date.civil(@year, @month, 1)
    @date_to = @date_from >> 1

    @events_by_day = {}

    unless params[:show_issues] == "0"
      @project.issues.find(:all, :include => [:author], :conditions => ["#{Issue.table_name}.created_on>=? and #{Issue.table_name}.created_on<=?", @date_from, @date_to] ).each { |i|
        @events_by_day[i.created_on.to_date] ||= []
        @events_by_day[i.created_on.to_date] << i
      }
      @show_issues = 1
    end

    unless params[:show_news] == "0"
      @project.news.find(:all, :conditions => ["#{News.table_name}.created_on>=? and #{News.table_name}.created_on<=?", @date_from, @date_to], :include => :author ).each { |i|
        @events_by_day[i.created_on.to_date] ||= []
        @events_by_day[i.created_on.to_date] << i
      }
      @show_news = 1
    end

    unless params[:show_files] == "0"
      Attachment.find(:all, :select => "#{Attachment.table_name}.*", :joins => "LEFT JOIN #{Version.table_name} ON #{Version.table_name}.id = #{Attachment.table_name}.container_id", :conditions => ["#{Attachment.table_name}.container_type='Version' and #{Version.table_name}.project_id=? and #{Attachment.table_name}.created_on>=? and #{Attachment.table_name}.created_on<=?", @project.id, @date_from, @date_to], :include => :author ).each { |i|
        @events_by_day[i.created_on.to_date] ||= []
        @events_by_day[i.created_on.to_date] << i
      }
      @show_files = 1
    end

    unless params[:show_documents] == "0"
      @project.documents.find(:all, :conditions => ["#{Document.table_name}.created_on>=? and #{Document.table_name}.created_on<=?", @date_from, @date_to] ).each { |i|
        @events_by_day[i.created_on.to_date] ||= []
        @events_by_day[i.created_on.to_date] << i
      }
      Attachment.find(:all, :select => "attachments.*", :joins => "LEFT JOIN #{Document.table_name} ON #{Document.table_name}.id = #{Attachment.table_name}.container_id", :conditions => ["#{Attachment.table_name}.container_type='Document' and #{Document.table_name}.project_id=? and #{Attachment.table_name}.created_on>=? and #{Attachment.table_name}.created_on<=?", @project.id, @date_from, @date_to], :include => :author ).each { |i|
        @events_by_day[i.created_on.to_date] ||= []
        @events_by_day[i.created_on.to_date] << i
      }
      @show_documents = 1
    end


    render :layout => false if request.xhr?
  end



  def feeds
    @queries = @project.queries.find :all, :conditions => ["is_public=? or user_id=?", true, (logged_in_user ? logged_in_user.id : 0)]
    @key = logged_in_user.get_or_create_rss_key.value if logged_in_user
  end

  private
  # Find project of id params[:id]
  # if not found, redirect to project list
  # Used as a before_filter
  def find_project
    @project = Project.find(params[:id])
    @html_title = @project.name
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def retrieve_selected_tracker_ids(selectable_trackers)
    if ids = params[:tracker_ids]
      @selected_tracker_ids = (ids.is_a? Array) ? ids.collect { |id| id.to_i.to_s } : ids.split('/').collect { |id| id.to_i.to_s }
    else
      @selected_tracker_ids = selectable_trackers.collect {|t| t.id.to_s }
    end
  end

  # Retrieve query from session or build a new query
  def retrieve_query
    if params[:query_id]
      @query = @project.queries.find(params[:query_id])
      @query.executed_by = logged_in_user
      session[:query] = @query
    else
      if params[:set_filter] or !session[:query] or session[:query].project_id != @project.id
        # Give it a name, required to be valid
        @query = Query.new(:name => "_", :executed_by => logged_in_user)
        @query.project = @project
        if params[:fields] and params[:fields].is_a? Array
          params[:fields].each do |field|
            @query.add_filter(field, params[:operators][field], params[:values][field])
          end
        else
          @query.available_filters.keys.each do |field|
            @query.add_short_filter(field, params[field]) if params[field]
          end
        end
        session[:query] = @query
      else
        @query = session[:query]
      end
    end
  end
end
