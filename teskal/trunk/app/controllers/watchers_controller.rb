# Copyright (C) 2007 Teskal


class WatchersController < ApplicationController
  layout 'base'
  before_filter :require_login, :find_project, :check_project_privacy
  
  def add
    user = logged_in_user
    @watched.add_watcher(user)
    respond_to do |format|
      format.html { render :text => 'Watcher added.', :layout => true }
      format.js { render(:update) {|page| page.replace_html 'watcher', watcher_link(@watched, user)} }
    end
  end
  
  def remove
    user = logged_in_user
    @watched.remove_watcher(user)
    respond_to do |format|
      format.html { render :text => 'Watcher removed.', :layout => true }
      format.js { render(:update) {|page| page.replace_html 'watcher', watcher_link(@watched, user)} }
    end
  end

private
  def find_project
    klass = Object.const_get(params[:object_type].camelcase)
    return false unless klass.respond_to?('watched_by')
    @watched = klass.find(params[:object_id])
    @project = @watched.project
  rescue
    render_404
  end
end
