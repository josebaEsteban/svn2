class Quest11Controller < ApplicationController
  layout 'base'
  before_filter :require_login , :require_suscription

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

  def show
    show_quest
    teskal_chart11
  end


  def teskal_chart11
    scale=10/7.0
    valor_bajo = 3
    valor_medio = 5
    @advice=[]
    @icon=[]

    #strXML will be used to store the entire XML document generated
    strXML=''

    # before scaling to base 10
    # yAxisMaxValue='7'

    #Generate the chart element
    if @answers.length > 1
      strXML = "<chart palette='2' caption='"+l(:quest11_label_0)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'  numDivLines='4' bgcolor='ffffff' borderColor='ffffff'>"
      strXML = strXML + "<categories>"
      strXML = strXML + "<category label= '"+l(:quest11_label_1)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest11_label_2)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest11_label_3)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest11_label_4)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest11_label_5)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest11_label_6)+"'/>"
      strXML = strXML + "</categories>"
    else
      strXML = "<chart caption='"+l(:quest11_label_0)+"' subCaption='"+@user.name+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    end

    for answer in @answers
      know = ((answer.answ2 + answer.answ5 + answer.answ26 + answer.answ30)/4.0 )
      accomplish = ((answer.answ9 + answer.answ13 + answer.answ16 + answer.answ22)/4.0 )
      experience = ((answer.answ1 + answer.answ14 + answer.answ20 + answer.answ28)/4.0 )
      motivacion_intrinseca= (know+accomplish+experience)/3.0

      item=0
      if motivacion_intrinseca < valor_bajo
        @advice[item]=l(:quest11_d1_a)
        @icon[item]="stop"
      else
        if motivacion_intrinseca < valor_medio
          @advice[item]=l(:quest11_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d1_c)
          @icon[item]="star"
        end
      end
      integrated_regulation = ((answer.answ4 + answer.answ18 + answer.answ24 + answer.answ31)/4.0 )
      item=1
      if integrated_regulation < valor_bajo
        @advice[item]=l(:quest11_d2_a)
        @icon[item]="stop"
      else
        if integrated_regulation < valor_medio
          @advice[item]=l(:quest11_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d2_c)
          @icon[item]="star"
        end
      end
      identified_regulation = ((answer.answ8 + answer.answ12 + answer.answ19 + answer.answ27)/4.0 )
      item=2
      if identified_regulation < valor_bajo
        @advice[item]=l(:quest11_d3_a)
        @icon[item]="stop"
      else
        if identified_regulation < valor_medio
          @advice[item]=l(:quest11_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d3_c)
          @icon[item]="star"
        end
      end
      introjected_regulation = ((answer.answ10 + answer.answ15 + answer.answ23 + answer.answ29)/4.0 )
      item=3
      if introjected_regulation < valor_bajo
        @advice[item]=l(:quest11_d4_a)
        @icon[item]="star"
      else
        if introjected_regulation < valor_medio
          @advice[item]=l(:quest11_d4_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d4_c)
          @icon[item]="stop"
        end
      end
      motivacion_extrinseca = ((answer.answ7 + answer.answ11 + answer.answ17 + answer.answ25)/4.0 )
      item=4
      if motivacion_extrinseca < valor_bajo
        @advice[item]=l(:quest11_d5_a)
        @icon[item]="star"
      else
        if motivacion_extrinseca < valor_medio
          @advice[item]=l(:quest11_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d5_c)
          @icon[item]="stop"
        end
      end
      amotivation = ((answer.answ3 + answer.answ6 + answer.answ21 + answer.answ32)/4.0 )
      item=5
      if amotivation < valor_bajo
        @advice[item]=l(:quest11_d6_a)
        @icon[item]="star"
      else
        if amotivation < valor_medio
          @advice[item]=l(:quest11_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest11_d6_c)
          @icon[item]="stop"
        end
      end
      valor_intrinseco =  (motivacion_intrinseca + integrated_regulation + identified_regulation) /3.0
      valor_extrinseco =  (introjected_regulation + motivacion_extrinseca + amotivation) / 3.0

      item=6
      if valor_intrinseco >=valor_medio
        if valor_extrinseco <=valor_bajo
          @advice[item]=l(:quest11_val_1)
          @titulo=l(:quest11_valor_tit_1)
        elsif valor_extrinseco >valor_bajo and  valor_extrinseco < valor_medio
          @advice[item]=l(:quest11_val_2)
          @titulo=l(:quest11_valor_tit_2)
        else
          @advice[item]=l(:quest11_val_3)
          @titulo=l(:quest11_valor_tit_3)
        end
      elsif valor_intrinseco >=valor_bajo
        if valor_extrinseco <=valor_bajo
          @advice[item]=l(:quest11_val_4)
          @titulo=l(:quest11_valor_tit_4)
        elsif valor_extrinseco >valor_bajo and  valor_extrinseco < valor_medio
          @advice[item]=l(:quest11_val_5)
          @titulo=l(:quest11_valor_tit_5)
        else
          @advice[item]=l(:quest11_val_6)
          @titulo=l(:quest11_valor_tit_6)
        end
      else
        if valor_extrinseco <=valor_bajo
          @advice[item]=l(:quest11_val_7)
          @titulo=l(:quest11_valor_tit_7)
        elsif valor_extrinseco >valor_bajo and  valor_extrinseco < valor_medio
          @advice[item]=l(:quest11_val_8)
          @titulo=l(:quest11_valor_tit_8)
        else
          @advice[item]=l(:quest11_val_9)
          @titulo=l(:quest11_valor_tit_9)
        end
      end
      if amotivation > valor_medio
        @advice[item]=l(:quest11_val_10)
        @titulo=l(:quest11_valor_tit_10)
      end      
      
      #Generate the chart element
      # labelDisplay='Stagger' staggerLines='2'
      # strXML = "<chart palette='2' caption='"+l(:quest11_label_0)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='7' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartLeftMargin='25' chartRightMargin='35'>"
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
      # strXML = strXML + "<set value='" + acorta(know) + "'/>"
      # strXML = strXML + "<set value='" + acorta(accomplish) + "'/>"
      # strXML = strXML + "<set value='" + acorta(experience) + "'/>"
      # strXML = strXML + "<set value='" + acorta(introjected_regulation) + "'/>"
      # strXML = strXML + "<set value='" + acorta(identified_regulation) + "'/>"
      # strXML = strXML + "<set value='" + acorta(identified_regulation)+ "'/>"
      # strXML = strXML + "<set value='" + acorta(externalRegulation) + "'/>"
      # strXML = strXML + "<set value='" + acorta(amotivation) + "'/>"
      # strXML = strXML + "</dataset> </chart>"
      # @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest11", 750, 300, false, false)

      if @answers.length > 1
        strXML = strXML +"<dataset SeriesName='"
        if answer.id == @id
          strXML = strXML+l(:quest3_label_10)
          strXML = strXML+"' renderAs='Bar' >"
        else
          strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))
          strXML = strXML+"' lineThickness='2' renderAs='Line' >"
        end
        strXML = strXML + "<set value='" + acorta(motivacion_intrinseca * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(integrated_regulation * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(identified_regulation * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(introjected_regulation * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(motivacion_extrinseca * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(amotivation * scale).to_s + "'/>"
        strXML = strXML + "</dataset>"
      else
        strXML = strXML + "<set label='" + l(:quest11_label_1) + "' value='" + acorta(motivacion_intrinseca * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest11_label_2) + "' value='" + acorta(integrated_regulation * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest11_label_3) + "' value='" + acorta(identified_regulation * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest11_label_4) + "' value='" + acorta(introjected_regulation * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest11_label_5) + "' value='" + acorta(motivacion_extrinseca * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest11_label_6) + "' value='" + acorta(amotivation * scale) + "'/>"
      end
    end
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    if @answers.length > 1
      #Create the chart - Pie 3D Chart with data from strXML
      @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest11", 780, 300, false, false)
    else
      @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest11", 600, 300, false, false)
    end
  end
end
