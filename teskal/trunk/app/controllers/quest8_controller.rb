class Quest8Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=8
    @answer.user_id=session[:user_id]
    @answer.ip = request.remote_ip
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
    require_coach(@answer.user_id)
    @user=User.find(@answer.user_id )
    require_coach(@answer.user_id)
    teskalChart8
  else

  end


  def teskalChart8
    # calculo de las dimensiones

    rg = (@answer.answ1 + @answer.answ2  + @answer.answ3 )/3.0
    dp = ( @answer.answ39 + @answer.answ40 + @answer.answ41  + @answer.answ42 )/4.0
    fe = ( @answer.answ32 + @answer.answ33 + @answer.answ34 )/3.0
    uc = ( @answer.answ7 + @answer.answ8 + @answer.answ9 + @answer.answ10 + @answer.answ11  )/5.0
    ei = ( @answer.answ23 + @answer.answ24 + @answer.answ25 )/3.0
    tp = ( @answer.answ18 + @answer.answ19 + @answer.answ20 + @answer.answ21 + @answer.answ22 )/5.0
    td = ( @answer.answ12 + @answer.answ13 + @answer.answ14 + @answer.answ15 + @answer.answ16 + @answer.answ17)/6.0
    re = ( @answer.answ4 + @answer.answ5 + @answer.answ6)/3.0
    it = ( @answer.answ26 + @answer.answ27 + @answer.answ28)/3.0
    ct = ( @answer.answ35 + @answer.answ36 + @answer.answ37 + @answer.answ38)/4.0

    @advice=[]
    @icon=[]
    item=0
    if rg < 3
      @advice[item]=l(:quest8_d0_a)
      @icon[item]="stop"
    else
      if rg < 5
        @advice[item]=l(:quest8_d0_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d0_c)
        @icon[item]="star"
      end
    end
    item=1
    if dp < 3
      @advice[item]=l(:quest8_d1_a)
      @icon[item]="stop"
    else
      if dp < 5
        @advice[item]=l(:quest8_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d1_c)
        @icon[item]="star"
      end
    end
    item=2
    if fe < 3
      @advice[item]=l(:quest8_d2_a)
      @icon[item]="stop"
    else
      if fe < 5
        @advice[item]=l(:quest8_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d2_b)
        @icon[item]="star"
      end
    end
    item=3
    if uc < 3
      @advice[item]=l(:quest8_d3_a)
      @icon[item]="stop"
    else
      if uc < 5
        @advice[item]=l(:quest8_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d3_c)
        @icon[item]="star"
      end
    end
    item=4
    if ei < 3
      @advice[item]=l(:quest8_d4_a)
      @icon[item]="stop"
    else
      if ei < 5
        @advice[item]=l(:quest8_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d4_c)
        @icon[item]="star"
      end
    end
    item=5
    if tp < 3
      @advice[item]=l(:quest8_d5_a)
      @icon[item]="stop"
    else
      if tp < 5
        @advice[item]=l(:quest8_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d5_c)
        @icon[item]="star"
      end
    end
    item=6
    if td < 3
      @advice[item]=l(:quest8_d6_a)
      @icon[item]="stop"
    else
      if td < 5
        @advice[item]=l(:quest8_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d6_c)
        @icon[item]="star"
      end
    end
    item=7
    if re < 3
      @advice[item]=l(:quest8_d7_a)
      @icon[item]="stop"
    else
      if re < 5
        @advice[item]=l(:quest8_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d7_c)
        @icon[item]="star"
      end
    end
    item=8
    if it < 3
      @advice[item]=l(:quest8_d8_a)
      @icon[item]="stop"
    else
      if it < 5
        @advice[item]=l(:quest8_d8_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d8_c)
        @icon[item]="star"
      end
    end
    item=9
    if ct < 3
      @advice[item]=l(:quest8_d9_a)
      @icon[item]="stop"
    else
      if ct < 5
        @advice[item]=l(:quest8_d9_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest8_d9_c)
        @icon[item]="star"
      end
    end

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest8_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='7' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest8_label_1) + "' value='" + acorta(rg) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_2) + "' value='" + acorta(dp) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_3) + "' value='" + acorta(fe) + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_4) + "' value='" + acorta(uc) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_5) + "' value='" + acorta(ei) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_6) + "' value='" + acorta(tp) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_7) + "' value='" + acorta(td) + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_8) + "' value='" + acorta(re) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_9) + "' value='" + acorta(it) + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_10) + "' value='" + acorta(ct) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest8", 600, 375, false, false)
  end
end
