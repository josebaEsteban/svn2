class Quest12Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    user=User.find(session[:user_id])
    user.start = Time.now
    if !params[:id].nil?
      user.filled_for = params[:id]
      passive = User.find_by_sql("select * from users where users.id=#{params[:id]}")
      @subject = passive[0].name
    else
      user.filled_for = session[:user_id]
    end
    user.save 
  end

  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=12
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
      if user.show?
        @answer.browse = true
      end
    else
      @answer.user_id = user.filled_for
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    @answer.browse=1
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest12/create/"+@answer.id.to_s, @answer.user_id)
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
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest12/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart12
  end


  def teskalChart12
    @advice=[]
    @icon=[]

    clima_rendimiento = (@answer.answ1 + @answer.answ2 + @answer.answ5 + @answer.answ6 + @answer.answ9 + @answer.answ12)/6.0
    clima_rendimiento = clima_rendimiento/10.0
    item=0
    if clima_rendimiento < 4
      @advice[item]=l(:quest12_d1_a)
      @icon[item]="stop"
    else
      if clima_rendimiento <= 7
        @advice[item]=l(:quest12_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest12_d1_c)
        @icon[item]="star"
      end
    end
    clima_maestria = (@answer.answ3 + @answer.answ4 + @answer.answ7 + @answer.answ8 + @answer.answ10 + @answer.answ11)/6.0
    clima_maestria = clima_maestria/10.0
    item=1
    if clima_maestria < 4
      @advice[item]=l(:quest12_d2_a)
      @icon[item]="stop"
    else
      if clima_maestria <= 7
        @advice[item]=l(:quest12_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest12_d2_c)
        @icon[item]="star"
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''

    strXML = "<chart caption='"+l(:quest12_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest12_label_1) + "' value='" + acorta(clima_rendimiento) + "'/>"
    strXML = strXML + "<set label='" + l(:quest12_label_2) + "' value='" + acorta(clima_maestria) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest8", 600, 185, false, false)
  end
end
