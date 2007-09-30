class Test7Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.questionnare_id=7
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
      @advice[0]=l(:test7_d1_a)
    else
      if rg < 5
        @advice[0]=l(:test7_d1_b)
      else
        @advice[0]=l(:test7_d1_c)
      end
    end
    if dp < 3
      @advice[1]=l(:test7_d2_a)
    else
      if dp < 5
        @advice[1]=l(:test7_d2_b)
      else
        @advice[1]=l(:test7_d2_c)
      end
    end
    if fe < 3
      @advice[2]=l(:test7_d3_a)
    else
      if fe < 5
        @advice[2]=l(:test7_d3_a)
      else
        @advice[2]=l(:test7_d3_a)
      end
    end
    if uc < 3
      @advice[3]=l(:test7_d4_a)
    else
      if uc < 5
        @advice[3]=l(:test7_d4_b)
      else
        @advice[3]=l(:test7_d4_c)
      end
    end
    if ei < 3
      @advice[4]=l(:test7_d5_a)
    else
      if ei < 5
        @advice[4]=l(:test7_d5_b)
      else
        @advice[4]=l(:test7_d5_c)
      end
    end
    if tp < 3
      @advice[5]=l(:test7_d6_a)
    else
      if tp < 5
        @advice[5]=l(:test7_d6_b)
      else
        @advice[5]=l(:test7_d6_c)
      end
    end
    rgs=rg.to_s
    if rgs.length>4
      rgs=rgs.slice(0,4)
    end
    dps=dp.to_s
    if dps.length>4
      dps=dps.slice(0,4)
    end
    fes=fe.to_s
    if fes.length>4
      fes=fes.slice(0,4)
    end
    ucs=uc.to_s
    if ucs.length>4
      ucs=ucs.slice(0,4)
    end
    if rgs.length>4
      rgs=rgs.slice(0,4)
    end
    eis=ei.to_s
    if eis.length>4
      eis=eis.slice(0,4)
    end
    tps=tp.to_s
    if tps.length>4
      tps=tps.slice(0,4)
    end
    #Generate the chart element
    strXML = "<chart caption='"+l(:test7_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='7' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:test7_label_1) + "' value='" + rgs + "'/>"
    strXML = strXML + "<set label='" + l(:test7_label_2) + "' value='" + dps + "'/>"
    strXML = strXML + "<set label='" + l(:test7_label_3) + "' value='" + fes + "'/>"
    strXML = strXML + "<set label='" + l(:test7_label_4) + "' value='" + ucs + "'/>"
    strXML = strXML + "<set label='" + l(:test7_label_5) + "' value='" + eis + "'/>"
    strXML = strXML + "<set label='" + l(:test7_label_6) + "' value='" + tps + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "test7", 550, 300, false, false)
  end
end
