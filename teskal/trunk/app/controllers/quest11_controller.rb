class Quest11Controller < ApplicationController
  layout 'base'
  before_filter :require_login , :require_suscription

  def new
    user=User.find(session[:user_id])
    user.start = Time.now
    user.save
  end 

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=11
    @answer.user_id=session[:user_id]
    @answer.ip = request.remote_ip
    user=User.find(session[:user_id])
    @answer.time_to_fill =  Time.now - user.start
    if @answer.save
      journal( "quest11/create/"+@answer.id.to_s, @answer.user_id) 
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
    journal( "quest11/show/"+@answer.id.to_s, @answer.user_id) 
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskal_chart11
  end


  def teskal_chart11
    @advice=[]
    @icon=[]

    toKnow = (@answer.answ2 + @answer.answ5 + @answer.answ26 + @answer.answ30)/4.0
    toAccomplish = (@answer.answ9 + @answer.answ13 + @answer.answ16 + @answer.answ22)/4.0
    toExperience = (@answer.answ1 + @answer.answ14 + @answer.answ20 + @answer.answ28)/4.0
    motivacionIntrinseca= (toKnow+toAccomplish+toExperience)/3.0

    item=0
    if motivacionIntrinseca < 3
      @advice[item]=l(:quest11_d1_a)
      @icon[item]="stop"
    else
      if motivacionIntrinseca < 5
        @advice[item]=l(:quest11_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d1_c)
        @icon[item]="star"
      end
    end
    integratedRegulation = (@answer.answ4 + @answer.answ18 + @answer.answ24 + @answer.answ31)/4.0
    item=1
    if integratedRegulation < 3
      @advice[item]=l(:quest11_d2_a)
      @icon[item]="stop"
    else
      if integratedRegulation < 5
        @advice[item]=l(:quest11_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d2_c)
        @icon[item]="star"
      end
    end
    identifiedRegulation = (@answer.answ8 + @answer.answ12 + @answer.answ19 + @answer.answ27)/4.0
    item=2
    if identifiedRegulation < 3
      @advice[item]=l(:quest11_d3_a)
      @icon[item]="stop"
    else
      if identifiedRegulation < 5
        @advice[item]=l(:quest11_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d3_c)
        @icon[item]="star"
      end
    end
    introjectedRegulation = (@answer.answ10 + @answer.answ15 + @answer.answ23 + @answer.answ29)/4.0
    item=3
    if introjectedRegulation < 3
      @advice[item]=l(:quest11_d4_a)
      @icon[item]="star"
    else
      if introjectedRegulation < 5
        @advice[item]=l(:quest11_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d4_c)
        @icon[item]="stop"
      end
    end
    motivacionExtrinseca = (@answer.answ7 + @answer.answ11 + @answer.answ17 + @answer.answ25)/4.0
    item=4
    if motivacionExtrinseca < 3
      @advice[item]=l(:quest11_d5_a)
      @icon[item]="star"
    else
      if motivacionExtrinseca < 5
        @advice[item]=l(:quest11_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d5_c)
        @icon[item]="stop"
      end
    end
    amotivation = (@answer.answ3 + @answer.answ6 + @answer.answ21 + @answer.answ32)/4.0
    item=5
    if amotivation < 3
      @advice[item]=l(:quest11_d6_a)
      @icon[item]="star"
    else
      if amotivation < 5
        @advice[item]=l(:quest11_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest11_d6_c)
        @icon[item]="stop"
      end
    end
    valorIntrinseco =  (motivacionIntrinseca + integratedRegulation + identifiedRegulation) /3.0
    valorExtrinseco =  (introjectedRegulation + motivacionExtrinseca + amotivation) / 3.0

    item=6
    if valorIntrinseco >=5
      if valorExtrinseco <=3
        @advice[item]=l(:quest11_val_1)
        @titulo=l(:quest11_valor_tit_1)
      elsif valorExtrinseco >3 and  valorExtrinseco < 5
        @advice[item]=l(:quest11_val_2)
        @titulo=l(:quest11_valor_tit_2)
      else
        @advice[item]=l(:quest11_val_3)
        @titulo=l(:quest11_valor_tit_3)
      end
    elsif valorIntrinseco >=3
      if valorExtrinseco <=3
        @advice[item]=l(:quest11_val_4)
        @titulo=l(:quest11_valor_tit_4)
      elsif valorExtrinseco >3 and  valorExtrinseco < 5
        @advice[item]=l(:quest11_val_5)
        @titulo=l(:quest11_valor_tit_5)
      else
        @advice[item]=l(:quest11_val_6)
        @titulo=l(:quest11_valor_tit_6)
      end
    else
      if valorExtrinseco <=3
        @advice[item]=l(:quest11_val_7)
        @titulo=l(:quest11_valor_tit_7)
      elsif valorExtrinseco >3 and  valorExtrinseco < 5
        @advice[item]=l(:quest11_val_8)
        @titulo=l(:quest11_valor_tit_8)
      else
        @advice[item]=l(:quest11_val_9)
        @titulo=l(:quest11_valor_tit_9)
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    # strXML = "<chart palette='2' caption='"+l(:quest11_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='7' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartLeftMargin='25' chartRightMargin='35'>"
    # strXML = strXML +"<categories>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_1)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_2)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_3)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_4)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_5)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_6)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_7)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest11_label_8)+"'/>"
    # strXML = strXML +"</categories>"
    # strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Area' >"
    # strXML = strXML +"<set value='2.5' /><set value='5' /><set value='5' /><set value='1' /><set value='5' /><set value='5' /><set value='5' /><set value='3' />"
    # strXML = strXML +"</dataset>"
    # strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_10)+"' lineThickness='4' renderAs='Line' >"
    # strXML = strXML + "<set value='" + acorta(toKnow) + "'/>"
    # strXML = strXML + "<set value='" + acorta(toAccomplish) + "'/>"
    # strXML = strXML + "<set value='" + acorta(toExperience) + "'/>"
    # strXML = strXML + "<set value='" + acorta(introjectedRegulation) + "'/>"
    # strXML = strXML + "<set value='" + acorta(identifiedRegulation) + "'/>"
    # strXML = strXML + "<set value='" + acorta(identifiedRegulation)+ "'/>"
    # strXML = strXML + "<set value='" + acorta(externalRegulation) + "'/>"
    # strXML = strXML + "<set value='" + acorta(amotivation) + "'/>"
    # strXML = strXML + "</dataset> </chart>"
    # @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest11", 750, 300, false, false)

    strXML = "<chart caption='"+l(:quest11_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='7' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest11_label_1) + "' value='" + acorta(motivacionIntrinseca) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_2) + "' value='" + acorta(integratedRegulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_3) + "' value='" + acorta(identifiedRegulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_4) + "' value='" + acorta(introjectedRegulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_5) + "' value='" + acorta(motivacionExtrinseca) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_6) + "' value='" + acorta(amotivation) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest8", 600, 300, false, false)
  end
end
