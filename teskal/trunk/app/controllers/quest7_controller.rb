class Quest7Controller < ApplicationController
  layout 'base'
  before_filter :require_login, :require_suscription

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
    @answer.quest_id=7
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
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest7/create/"+@answer.id.to_s, @answer.user_id)
      # pendings = Pending.find_by_sql("select id from pendings where pendings.user_id=#{@answer.user_id} and pendings.quest_id=#{@answer.quest_id} order by pendings.created_on ASC")
      # if pendings.length >0
      #   Pending.delete(pendings[0])
      # end

      quest = Quest.find(:first, :conditions  => {:user_id  => @answer.user_id, :order => 7})
      quest.toggle!(:browse)

      if user.show?
        redirect_to :action => 'show', :id => @answer.id
      else
        redirect_to :controller  => 'my', :action  => 'page'
      end

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
    journal( "quest7/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart7
  end


  def teskalChart7
    scale=10/7.0
    # calculo de las dimensiones

    rg = (( @answer.answ1 + @answer.answ2  + @answer.answ3 )/3.0 ) * scale
    uc = (( @answer.answ4 + @answer.answ5 + @answer.answ6 )/3.0 ) * scale
    fe = (( @answer.answ13 + @answer.answ14 + @answer.answ15 )/3.0 ) * scale
    dp = (( @answer.answ16 + @answer.answ17 + @answer.answ18  )/3.0 ) * scale
    ei = (( @answer.answ10 + @answer.answ11 + @answer.answ12 )/3.0 ) * scale
    tp = (( @answer.answ7 + @answer.answ8 + @answer.answ9 )/3.0 ) * scale

    @advice=[]
    @icon=[]
    item=0
    if rg < 3 * scale
      @advice[item]=l(:quest7_d1_a)
      @icon[item]="stop"
    else
      if rg < 5 * scale
        @advice[item]=l(:quest7_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d1_c)
        @icon[item]="star"
      end
    end
    item=1
    if dp < 3 * scale
      @advice[item]=l(:quest7_d2_a)
      @icon[item]="stop"
    else
      if dp < 5 * scale
        @advice[item]=l(:quest7_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d2_c)
        @icon[item]="star"
      end
    end
    item=2
    if fe < 3 * scale
      @advice[item]=l(:quest7_d3_a)
      @icon[item]="stop"
    else
      if fe < 5 * scale
        @advice[item]=l(:quest7_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d3_c)
        @icon[item]="star"
      end
    end
    item=3
    if uc < 3 * scale
      @advice[item]=l(:quest7_d4_a)
      @icon[item]="stop"
    else
      if uc < 5 * scale
        @advice[item]=l(:quest7_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d4_c)
        @icon[item]="star"
      end
    end
    item=4
    if ei < 3 * scale
      @advice[item]=l(:quest7_d5_a)
      @icon[item]="stop"
    else
      if ei < 5 * scale
        @advice[item]=l(:quest7_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d5_c)
        @icon[item]="star"
      end
    end
    item=5
    if tp < 3 * scale
      @advice[item]=l(:quest7_d6_a)
      @icon[item]="stop"
    else
      if tp < 5 * scale
        @advice[item]=l(:quest7_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest7_d6_c)
        @icon[item]="star"
      end
    end

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest7_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    # before scaling to base 10
    # yAxisMaxValue='7'

    strXML = strXML + "<set label='" + l(:quest7_label_1) + "' value='" + acorta(rg) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_2) + "' value='" + acorta(dp) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_3) + "' value='" + acorta(fe) + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest7_label_4) + "' value='" + acorta(uc) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_5) + "' value='" + acorta(ei) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_6) + "' value='" + acorta(tp) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest7", 550, 300, false, false)
  end
end
