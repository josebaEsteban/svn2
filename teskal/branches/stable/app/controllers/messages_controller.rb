# Teskal
# Copyright (C) 2007 Teskal



class MessagesController < ApplicationController
  layout 'base'
  before_filter :find_project, :check_project_privacy
  before_filter :require_login, :only => [:new, :reply]

  verify :method => :post, :only => [ :reply, :destroy ], :redirect_to => { :action => :show }

  helper :attachments
  include AttachmentsHelper   

  def show
    @reply = Message.new(:subject => "RE: #{@message.subject}")
    render :action => "show", :layout => false if request.xhr?
  end
  
  def new
    @message = Message.new(params[:message])
    @message.author = logged_in_user
    @message.board = @board 
    if request.post? && @message.save
      params[:attachments].each { |file|
        next unless file.size > 0
        Attachment.create(:container => @message, :file => file, :author => logged_in_user)
      } if params[:attachments] and params[:attachments].is_a? Array    
      redirect_to :action => 'show', :id => @message
    end
  end

  def reply
    @reply = Message.new(params[:reply])
    @reply.author = logged_in_user
    @reply.board = @board
    @message.children << @reply
    redirect_to :action => 'show', :id => @message
  end
  
private
  def find_project
    @board = Board.find(params[:board_id], :include => :project)
    @project = @board.project
    @message = @board.topics.find(params[:id]) if params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end