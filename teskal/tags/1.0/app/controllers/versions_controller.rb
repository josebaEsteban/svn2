# Teskal
#


class VersionsController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize

  def edit
    if request.post? and @version.update_attributes(params[:version])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'versions', :id => @project
    end
  end

  def destroy
    @version.destroy
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'versions', :id => @project
  rescue
    flash[:notice] = "Unable to delete version"
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'versions', :id => @project
  end

  def download
    @attachment = @version.attachments.find(params[:attachment_id])
    @attachment.increment_download
    send_file @attachment.diskfile, :filename => @attachment.filename
  rescue
    render_404
  end 
  
  def destroy_file
    @version.attachments.find(params[:attachment_id]).destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :controller => 'projects', :action => 'list_files', :id => @project
  end

private
  def find_project
    @version = Version.find(params[:id])
    @project = @version.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end  
end
