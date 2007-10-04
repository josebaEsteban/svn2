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
    teskalChart8
  end


  def teskalChart8
    # calculo de las dimensiones

    rg = (@answer.answ1 + @answer.answ2  + @answer.answ3 )/3.0
    uc = ( @answer.answ39 + @answer.answ30 + @answer.answ39  + @answer.answ42 )/4.0
    fe = ( @answer.answ32 + @answer.answ33 + @answer.answ34 )/3.0
    dp = ( @answer.answ7 + @answer.answ8 + @answer.answ9 + @answer.answ10 + @answer.answ11  )/5.0
    ei = ( @answer.answ23 + @answer.answ24 + @answer.answ25 )/3.0
    tp = ( @answer.answ18 + @answer.answ19 + @answer.answ20 + @answer.answ21 + @answer.answ22 )/5.0
    td = ( @answer.answ14 + @answer.answ15 + @answer.answ16 + @answer.answ17)/4.0
    re = ( @answer.answ4 + @answer.answ5 + @answer.answ6)/4.0
    it = ( @answer.answ26 + @answer.answ27 + @answer.answ28)/3.0
    ct = ( @answer.answ35 + @answer.answ36 + @answer.answ37 + @answer.answ38)/4.0

    @advice=[]
    if rg < 3
      @advice[0]=l(:quest8_d1_a)
    else
      if rg < 5
        @advice[0]=l(:quest8_d1_b)
      else
        @advice[0]=l(:quest8_d1_c)
      end
    end
    if uc < 3
      @advice[1]=l(:quest8_d2_a)
    else
      if uc < 5
        @advice[1]=l(:quest8_d2_b)
      else
        @advice[1]=l(:quest8_d2_c)
      end
    end
    if fe < 3
      @advice[2]=l(:quest8_d3_a)
    else
      if fe < 5
        @advice[2]=l(:quest8_d3_a)
      else
        @advice[2]=l(:quest8_d3_a)
      end
    end
    if dp < 3
      @advice[3]=l(:quest8_d4_a)
    else
      if dp < 5
        @advice[3]=l(:quest8_d4_b)
      else
        @advice[3]=l(:quest8_d4_c)
      end
    end
    if ei < 3
      @advice[4]=l(:quest8_d5_a)
    else
      if ei < 5
        @advice[4]=l(:quest8_d5_b)
      else
        @advice[4]=l(:quest8_d5_c)
      end
    end
    if tp < 3
      @advice[5]=l(:quest8_d6_a)
    else
      if tp < 5
        @advice[5]=l(:quest8_d6_b)
      else
        @advice[5]=l(:quest8_d6_c)
      end
    end
    if td < 3
      @advice[0]=l(:quest8_d7_a)
    else
      if td < 5
        @advice[0]=l(:quest8_d7_b)
      else
        @advice[0]=l(:quest8_d7_c)
      end
    end
    if re < 3
      @advice[6]=l(:quest8_d8_a)
    else
      if re < 5
        @advice[6]=l(:quest8_d8_b)
      else
        @advice[6]=l(:quest8_d8_c)
      end
    end
    if it < 3
      @advice[0]=l(:quest8_d9_a)
    else
      if it < 5
        @advice[0]=l(:quest8_d9_b)
      else
        @advice[0]=l(:quest8_d9_c)
      end
    end
    if ct < 3
      @advice[0]=l(:quest8_d10_a)
    else
      if ct < 5
        @advice[0]=l(:quest8_d10_b)
      else
        @advice[0]=l(:quest8_d10_c)
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
    eis=ei.to_s
    if eis.length>4
      eis=eis.slice(0,4)
    end
    tps=tp.to_s
    if tps.length>4
      tps=tps.slice(0,4)
    end
    tds=td.to_s
    if tds.length>4
      tds=fes.slice(0,4)
    end
    res=re.to_s
    if res.length>4
      res=ucs.slice(0,4)
    end
    its=it.to_s
    if its.length>4
      its=its.slice(0,4)
    end
    cts=ct.to_s
    if cts.length>4
      cts=cts.slice(0,4)
    end
    #Generate the chart element
    strXML = "<chart caption='"+l(:quest8_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='7' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest8_label_1) + "' value='" + rgs + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_8) + "' value='" + dps + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_3) + "' value='" + fes + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_2) + "' value='" + ucs + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_5) + "' value='" + eis + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_6) + "' value='" + tps + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_7) + "' value='" + tds + "'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_8) + "' value='" + res + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_9) + "' value='" + its + "'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_10) + "' value='" + cts + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "quest8", 550, 375, false, false)
  end
end
