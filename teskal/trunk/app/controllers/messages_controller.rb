# Copyright (C) 2007 Teskal

class MessagesController < ApplicationController
  layout 'base'
  before_filter :require_login,:find_board

  def new

  end

  def create
    message = Message.new(params[:message])
    message.author = logged_in_user
    message.board_id = params[:id]
    if message.save
      redirect_to :action => 'show', :id  => params[:id]
    end
  end

  def show
    @messages = Message.paginate_by_board_id(@board.id,:page => params[:page], :per_page => 15, :order => 'created_on DESC')
  end

  def find_board
    if params[:id].nil?
      @board = @logged_in_user
    else
      @board = User.find(params[:id])
    end
    if @board.managed_by != @logged_in_user.id and @board.id != @logged_in_user.id and !@logged_in_user.admin?
      flash.now[:notice] = l(:notice_not_authorized)
      redirect_to :controller => 'my', :action => 'page'
    end
  end

end
