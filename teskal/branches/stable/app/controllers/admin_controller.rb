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
    @notifiables = %w(issue_added issue_updated news_added document_added file_added message_posted)
    if request.post?
      settings = (params[:settings] || {}).dup.symbolize_keys
      settings[:notified_events] ||= []
      settings.each { |name, value| Setting[name] = value }
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'admin', :action => 'mail_options'
    end
  end

  def test_email
    raise_delivery_errors = ActionMailer::Base.raise_delivery_errors
    # Force ActionMailer to raise delivery errors so we can catch it
    ActionMailer::Base.raise_delivery_errors = true
    begin
      @test = Mailer.deliver_test(User.current)
      flash[:notice] = l(:notice_email_sent, User.current.mail)
    rescue Exception => e
      flash[:error] = l(:notice_email_error, e.message)
    end
    ActionMailer::Base.raise_delivery_errors = raise_delivery_errors
    redirect_to :action => 'mail_options'
  end

  def info
    @db_adapter_name = ActiveRecord::Base.connection.adapter_name
    @flags = {
      :default_admin_changed => User.find(:first, :conditions => ["login=? and hashed_password=?", 'admin', User.hash_password('admin')]).nil?,
      :file_repository_writable => File.writable?(Attachment.storage_path),
      :rmagick_available => Object.const_defined?(:Magick)
    }
    # @plugins = Teskal::Plugin.registered_plugins
  end

  def stats
    @users = User.count_by_sql "select count(*) from users"
    @quests = Answer.count_by_sql "select count(*) from answers"
    @journals = Journal.find_by_sql("select * from journals order by journals.created_on desc")
  end
end
