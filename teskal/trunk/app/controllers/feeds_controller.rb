# Teskal

# Copyright (C) 2007 Teskal



class FeedsController < ApplicationController
  before_filter :find_scope
  session :off

  helper :issues
  include IssuesHelper
    
  # news feeds
  def news
    News.with_scope(:find => @find_options) do
      @news = News.find :all, :order => "#{News.table_name}.created_on DESC", :include => [ :author, :project ]
    end
    headers["Content-Type"] = "application/rss+xml"
    render :action => 'news_atom' if 'atom' == params[:format]
  end
  
  # issue feeds
  def issues
    if @project && params[:query_id]
      query = Query.find(params[:query_id])
      query.executed_by = @user
      # ignore query if it's not valid
      query = nil unless query.valid?
      # override with query conditions
      @find_options[:conditions] = query.statement if query.valid? and @project == query.project
    end

    @title = (@project ? @project.name : Setting.app_title) + ": " + (query ? query.name : l(:label_reported_issues))
    headers["Content-Type"] = "application/rss+xml"
    render :action => 'issues_atom' if 'atom' == params[:format]
  end
  
  # issue changes feeds
  def history    
    if @project && params[:query_id]
      query = Query.find(params[:query_id])
      query.executed_by = @user
      # ignore query if it's not valid
      query = nil unless query.valid?
      # override with query conditions
      @find_options[:conditions] = query.statement if query.valid? and @project == query.project
    end

     
    @title = (@project ? @project.name : Setting.app_title) + ": " + (query ? query.name : l(:label_reported_issues))
    headers["Content-Type"] = "application/rss+xml"
    render :action => 'history_atom' if 'atom' == params[:format]
  end
   
private
  # override for feeds specific authentication
  def check_if_login_required
    @user = User.find_by_rss_key(params[:key])
    render(:nothing => true, :status => 403) and return false if !@user && Setting.login_required?
  end
  
  def find_scope
    if params[:project_id]
      # project feed
      # check if project is public or if the user is a member
      @project = Project.find(params[:project_id])
      render(:nothing => true, :status => 403) and return false unless @project.is_public? || (@user && @user.role_for_project(@project))
      scope = ["#{Project.table_name}.id=?", params[:project_id].to_i]
    else
      # global feed
      scope = ["#{Project.table_name}.is_public=?", true]
    end
    @find_options = {:conditions => scope, :limit => Setting.feeds_limit.to_i}
    return true
  end
end
