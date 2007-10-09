class Quest7Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=7
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
    teskalChart7
  end


  def teskalChart7
    # calculo de las dimensiones

    rg = (@answer.answ1 + @answer.answ2  + @answer.answ3 )/3.0
    uc = ( @answer.answ4 + @answer.answ5 + @answer.answ6 )/3.0
    fe = ( @answer.answ13 + @answer.answ14 + @answer.answ15 )/3.0
    dp = ( @answer.answ16 + @answer.answ17 + @answer.answ18  )/3.0
    ei = ( @answer.answ10 + @answer.answ11 + @answer.answ12 )/3.0
    tp = ( @answer.answ7 + @answer.answ8 + @answer.answ9 )/3.0

    @advice=[]
    if rg < 3
      @advice[0]=l(:quest7_d1_a)
    else
      if rg < 5
        @advice[0]=l(:quest7_d1_b)
      else
        @advice[0]=l(:quest7_d1_c)
      end
    end
    if dp < 3
      @advice[1]=l(:quest7_d2_a)
    else
      if dp < 5
        @advice[1]=l(:quest7_d2_b)
      else
        @advice[1]=l(:quest7_d2_c)
      end
    end
    if fe < 3
      @advice[2]=l(:quest7_d3_a)
    else
      if fe < 5
        @advice[2]=l(:quest7_d3_a)
      else
        @advice[2]=l(:quest7_d3_a)
      end
    end
    if uc < 3
      @advice[3]=l(:quest7_d4_a)
    else
      if uc < 5
        @advice[3]=l(:quest7_d4_b)
      else
        @advice[3]=l(:quest7_d4_c)
      end
    end
    if ei < 3
      @advice[4]=l(:quest7_d5_a)
    else
      if ei < 5
        @advice[4]=l(:quest7_d5_b)
      else
        @advice[4]=l(:quest7_d5_c)
      end
    end
    if tp < 3
      @advice[5]=l(:quest7_d6_a)
    else
      if tp < 5
        @advice[5]=l(:quest7_d6_b)
      else
        @advice[5]=l(:quest7_d6_c)
      end
    end

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest7_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='7' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:quest7_label_1) + "' value='" + acorta(rg) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_2) + "' value='" + acorta(dp) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_3) + "' value='" + acorta(fe) + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest7_label_4) + "' value='" + acorta(uc) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_5) + "' value='" + acorta(ei) + "'/>"
    strXML = strXML + "<set label='" + l(:quest7_label_6) + "' value='" + acorta(tp) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "quest7", 550, 300, false, false)
  end
end
