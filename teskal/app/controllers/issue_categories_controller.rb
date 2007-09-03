# Teskal

class IssueCategoriesController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize

  def edit
    if request.post? and @category.update_attributes(params[:category])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'categories', :id => @project
    end
  end

  def destroy
    @category.destroy
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'categories', :id => @project
  rescue
    flash[:notice] = "Categorie can't be deleted"
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'categories', :id => @project
  end

private
  def find_project
    @category = IssueCategory.find(params[:id])
    @project = @category.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end    
end
