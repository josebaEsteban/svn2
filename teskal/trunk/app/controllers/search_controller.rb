# Teskal




class SearchController < ApplicationController
  layout 'base'

  helper :messages
  include MessagesHelper

  def index
    @question = params[:q] || ""
    @question.strip!
    @all_words = params[:all_words] || (params[:submit] ? false : true)
    @scope = params[:scope] || (params[:submit] ? [] : %w(projects issues news documents messages) )
    
    # quick jump to an issue
    if @scope.include?('issues') && @question.match(/^#?(\d+)$/) && Issue.find_by_id($1, :include => :project, :conditions => Project.visible_by(logged_in_user))
      redirect_to :controller => "issues", :action => "show", :id => $1
      return
    end
    
    if params[:id]
      find_project
      return unless check_project_privacy
    end
    
    # tokens must be at least 3 character long
    @tokens = @question.split.uniq.select {|w| w.length > 2 }
    
    if !@tokens.empty?
      # no more than 5 tokens to search for
      @tokens.slice! 5..-1 if @tokens.size > 5
      # strings used in sql like statement
      like_tokens = @tokens.collect {|w| "%#{w.downcase}%"}
      operator = @all_words ? " AND " : " OR "
      limit = 10
      @results = []
      if @project
        @results += @project.issues.find(:all, :limit => limit, :include => :author, :conditions => [ (["(LOWER(subject) like ? OR LOWER(description) like ?)"] * like_tokens.size).join(operator), * (like_tokens * 2).sort] ) if @scope.include? 'issues'
        Message.with_scope :find => {:conditions => ["#{Board.table_name}.project_id = ?", @project.id]} do
          @results += Message.find(:all, :include => :board, :limit => limit, :conditions => [ (["(LOWER(subject) like ? OR LOWER(content) like ?)"] * like_tokens.size).join(operator), * (like_tokens * 2).sort] ) if @scope.include? 'messages'
        end
      else
        Project.with_scope(:find => {:conditions => Project.visible_by(logged_in_user)}) do
          @results += Project.find(:all, :limit => limit, :conditions => [ (["(LOWER(name) like ? OR LOWER(description) like ?)"] * like_tokens.size).join(operator), * (like_tokens * 2).sort] ) if @scope.include? 'projects'
        end
        # if only one project is found, user is redirected to its overview
        redirect_to :controller => 'projects', :action => 'show', :id => @results.first and return if @results.size == 1
      end
      @question = @tokens.join(" ")
    else
      @question = ""
    end
  end

private  
  def find_project
    @project = Project.find(params[:id])
    @html_title = @project.name
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
