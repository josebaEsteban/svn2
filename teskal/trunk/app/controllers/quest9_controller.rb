class Quest9Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=9
    @answer.user_id=session[:user_id]
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      redirect_to :action => 'show', :id => @answer.id

      # format.html { redirect_to answer_url(@answer) }
      # format.xml  { head :created, :location => answer_url(@answer) }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @answer.errors.to_xml }
    end
  end

  def show
    @answer = Answer.find(params[:id])
    @fecha = l_datetime(@answer.created_on)

    @user=User.find(@answer.user_id )
    teskalChart9
  end


  def teskalChart9
     @advice=[]
    @advice[0]=0
    @advice[1]=0
    @advice[2]=0
    @advice[3]=0
    @advice[4]=0
    @advice[5]=0
    # @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "quest9", 600, 375, false, false)
  end
end
