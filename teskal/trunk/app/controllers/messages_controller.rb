# Copyright (C) 2007 Teskal

class MessagesController < ApplicationController
  layout 'base'
  before_filter :require_login,:find_board, :require_suscription

  def new

  end

  def create
    add_here
    journal( "mailer/add_message_to/"+destino.id.to_s, @logged_in_user.id)
    redirect_to :action => 'show', :id  => params[:id]
  end

  def add_from_quest
    add_here      
    journal( "mailer/quest_message_to/"+destino.id.to_s, @logged_in_user.id)
    # this must be ajaxed - this query is too much
    answer = Answer.find(@which_answer) 
    controlador = "quest"+answer.quest_id.to_s
    redirect_to :controller  => controlador, :action => 'show', :id => @which_answer
  end

  def add_here
    message = Message.new(params[:message])
    @which_answer = message.answer_id
    message.author_id = @logged_in_user.id
    message.board_id = params[:id]
    message.save
    if @logged_in_user.id == message.board_id
      if !@logged_in_user.managed_by.nil?
        destino = User.find(@logged_in_user.managed_by)
        Mailer.deliver_message_posted(@logged_in_user,destino,message.content)
        journal( "mailer/message_to/"+destino.id.to_s, message.author_id)
      end
    else
      destino = User.find(message.board_id)
      Mailer.deliver_message_posted(@logged_in_user,destino,message.content)
      journal( "mailer/message_to/"+destino.id.to_s, message.author_id)
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
