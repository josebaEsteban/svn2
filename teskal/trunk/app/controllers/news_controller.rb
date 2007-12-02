# Teskal


class NewsController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize

  def show
  end

  def edit
    if request.post? and @news.update_attributes(params[:news])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @news
    end
  end
  
  def add_comment
    @comment = Comment.new(params[:comment])
    @comment.author = logged_in_user
    if @news.comments << @comment
      flash[:notice] = l(:label_comment_added)
      redirect_to :action => 'show', :id => @news
    else
      render :action => 'show'
    end
  end

  def destroy_comment
    @news.comments.find(params[:comment_id]).destroy
    redirect_to :action => 'show', :id => @news
  end

  def destroy
    @news.destroy
    redirect_to :controller => 'projects', :action => 'list_news', :id => @project
  end
  
private
  def find_project
    @news = News.find(params[:id])
    @project = @news.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end  
end
