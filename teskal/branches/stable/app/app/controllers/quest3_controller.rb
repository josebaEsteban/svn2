class Quest3Controller < ApplicationController
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

  def show
    show_quest
    teskalChart3
  end


  def teskalChart3
    # transformadas
    tVal = %w(36 36 38 42 46 49 53 57 60 64 68 71 75)
    dVal = %w(41 45 49 52 56 60 64 67 71 75 79 79 79)
    hVal = %w(38 42 45 49 53 56 60 63 67 70 74 77 79)
    vVal = %w(36 36 36 37 41 44 48 51 55 59 62 66 69)
    fVal = %w(36 39 42 45 49 52 55 59 62 65 68 72 75)

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element

    strXML = "<chart palette='2' caption='"+l(:quest3_label_0)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'   bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
    strXML = strXML + "<categories>"
    strXML = strXML + "<category label= '"+l(:quest3_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest3_label_8)+"'/>"
    strXML = strXML + "</categories>"
    strXML = strXML + "<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Area' >"
    strXML = strXML + "<set value='40' /><set value='36' /><set value='40' /><set value='70' /><set value='38' /><set value='70' /><set value='38' /><set value='70' />"
    strXML = strXML + "</dataset>"

    for answer in @answers
      # calculo de las dimensiones

      tension = answer.answ1 + answer.answ6  + answer.answ11
      depresion = answer.answ2 + answer.answ7 + answer.answ12
      hostilidad = answer.answ5 + answer.answ10 + answer.answ15
      vigor = answer.answ4 + answer.answ9 + answer.answ14
      fatiga = answer.answ3 + answer.answ8 + answer.answ13
      compromiso_esfuerzo = ((answer.answ16 + answer.answ19 + answer.answ22)*3.0).round
      ansiedad_errores = ((answer.answ18 + answer.answ21 + answer.answ24)*3.0).round
      competencia_percibida = ((answer.answ17 + answer.answ20 + answer.answ23)*3.0).round

      @advice=[]
      @icon=[]
      item=0
      if tension < 5
        @advice[item]=l(:quest3_d1_a)
        @icon[item]="star"
      else
        if tension < 9
          @advice[item]=l(:quest3_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d1_c)
          @icon[item]="stop"
        end
      end
      item=1
      if depresion < 2
        @advice[item]=l(:quest3_d2_a)
        @icon[item]="star"
      else
        if depresion < 6
          @advice[item]=l(:quest3_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d2_c)
          @icon[item]="stop"
        end
      end
      item=2
      if hostilidad < 3
        @advice[item]=l(:quest3_d3_a)
        @icon[item]="star"
      else
        if hostilidad < 7
          @advice[item]=l(:quest3_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d3_c)
          @icon[item]="stop"
        end
      end
      item=3
      if vigor < 7
        @advice[item]=l(:quest3_d4_a)
        @icon[item]="stop"
      else
        if vigor < 10
          @advice[item]=l(:quest3_d4_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d4_c)
          @icon[item]="star"
        end
      end
      item=4
      if fatiga < 4
        @advice[item]=l(:quest3_d5_a)
        @icon[item]="star"
      else
        if fatiga < 8
          @advice[item]=l(:quest3_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d5_c)
          @icon[item]="stop"
        end
      end
      item=5
      if compromiso_esfuerzo < 13
        @advice[item]=l(:quest3_d6_a)
        @icon[item]="stop"
      else
        if compromiso_esfuerzo < 25
          @advice[item]=l(:quest3_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d6_c)
          @icon[item]="star"
        end
      end
      item=6
      if ansiedad_errores < 13
        @advice[item]=l(:quest3_d7_a)
        @icon[item]="star"
      else
        if ansiedad_errores < 25
          @advice[item]=l(:quest3_d7_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d7_c)
          @icon[item]="stop"
        end
      end
      item=7
      if competencia_percibida < 13
        @advice[item]=l(:quest3_d8_a)
        @icon[item]="stop"
      else
        if competencia_percibida < 25
          @advice[item]=l(:quest3_d8_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest3_d8_c)
          @icon[item]="star"
        end
      end

      tTrans=tVal[tension]
      dTrans=dVal[depresion]
      hTrans=hVal[hostilidad]
      vTrans=vVal[vigor]
      fTrans=fVal[fatiga]
      ceTrans=compromiso_esfuerzo+36
      aeTrans=ansiedad_errores+36
      cpTrans=competencia_percibida+36

      strXML = strXML + "<dataset SeriesName='"
      if answer.id == @id
        strXML = strXML+l(:quest3_label_10)+"' lineThickness='4' "
      else
        strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))+"' anchorSides='4' lineThickness='1' "
      end     
      strXML = strXML + " renderAs='Line' >"
      strXML = strXML + "<set value='" + tTrans + "'/>"
      strXML = strXML + "<set value='" + dTrans + "'/>"
      strXML = strXML + "<set value='" + hTrans + "'/>"
      strXML = strXML + "<set value='" + vTrans + "'/>"
      strXML = strXML + "<set value='" + fTrans + "'/>"
      strXML = strXML + "<set value='" + ceTrans.to_s + "'/>"
      strXML = strXML + "<set value='" + aeTrans.to_s + "'/>"
      strXML = strXML + "<set value='" + cpTrans.to_s + "'/>"
      strXML = strXML + "</dataset>"
    end
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)
  end
end
