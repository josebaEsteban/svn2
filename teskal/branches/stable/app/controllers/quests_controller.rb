class QuestsController < ApplicationController
  before_filter :require_login

  def index
    @users = User.find(:all)
    for user in @users
      1.upto(Quest::CATALOG) {|number| quest = Quest.new
        quest.user_id = user.id
        quest.order = number
        if user.show?
          quest.browse = true
        else
          if Quest::FREE.include?(number)
            quest.browse = true
          else
            quest.browse = false
          end
        end
      quest.save}
    end
  end

  def switch
    quest = Quest.find(params[:id])
    user = User.find(quest.user_id)
    if @logged_in_user.admin? or @logged_in_user.id == user.managed_by
      quest.toggle!(:browse)
      journal( "quest/"+quest.browse.to_s+"/"+quest.order.to_s+"/"+user.id.to_s, @logged_in_user.id)
      redirect_to :controller => 'my', :action => 'admin' , :id  => quest.user_id.to_s
    else
      redirect_to :controller => 'my', :action => 'page'
    end
  end

  # todos los quest se crean aqui
  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=(params[:id])
    # rellenado por si mismo
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
      if user.show?
        @answer.browse = true
      else
        if user.gratis? and Quest::FREE.include?(@answer.quest_id)
          @answer.browse = true
        else
          @answer.browse = false
        end
      end
    else
      @answer.user_id = user.filled_for
      @answer.browse = false
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    # @answer.created_on = params[:created_on]
    # paso = Time.parse(@answer.created_on)
    # @answer.created_on = paso.to_datetime
    # para quest 1 y 2
    if @answer.quest_id == 1 or @answer.quest_id == 3
      if @answer.answ24.nil?
        @answer.answ24=0
      end
      if @answer.answ25.nil?
        @answer.answ25=0
      end
    end
    if !@answer.created_on.nil?
      @answer.created_on=TzTime.zone.local_to_utc(@answer.created_on)
    end
    if @answer.save
      flash[:notice] = l(:notice_successful_create)
      controlador = "quest"+@answer.quest_id.to_s
      journal( controlador+"/create/"+@answer.id.to_s, @answer.user_id)
      quest = Quest.find(:first, :conditions  => {:user_id  => @answer.user_id, :order => @answer.quest_id})
      quest.toggle!(:browse)
      user=User.find(@answer.user_id)
      # if user.admin?
      #   Mailer.deliver_quest(@answer,user)
      # elsif !user.managed_by.nil?
      #   manager=User.find(user.managed_by)
      #   Mailer.deliver_quest(@answer,manager)
      # end
      if answer_show?(@answer.user_id, @answer.browse, user.managed_by)

        redirect_to :controller  => controlador, :action => 'show', :id => @answer.id
      else
        redirect_to :controller => 'my', :action => 'page'
      end
      # format.html { redirect_to answer_url(@answer) }
      # format.xml  { head :created, :location => answer_url(@answer) }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @answer.errors.to_xml }
    end
  end

end
