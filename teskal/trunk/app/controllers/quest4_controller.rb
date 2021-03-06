class Quest4Controller < ApplicationController
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
    teskalChart4
  end

  def teskalChart4

    # Transformadas
    tVal = %w(36 36 38 42 46 49 53 57 60 64 68 71 75)
    dVal = %w(41 45 49 52 56 60 64 67 71 75 79 79 79)
    hVal = %w(38 42 45 49 53 56 60 63 67 70 74 77 79)
    vVal = %w(36 36 36 37 41 44 48 51 55 59 62 66 69)
    fVal = %w(36 39 42 45 49 52 55 59 62 65 68 72 75)

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest4_label_1)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:quest1_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_8)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_9)+"' lineThickness='3' renderAs='Area' >"
    strXML = strXML +"<set value='42' /><set value='37' /><set value='40' /><set value='68' /><set value='38' /><set value='42' /><set value='68' /><set value='38' />"
    strXML = strXML +"</dataset>"

    for answer in @answers
      tension = answer.answ1 + answer.answ6  + answer.answ11
      depresion = answer.answ2 + answer.answ7 + answer.answ12
      hostilidad = answer.answ5 + answer.answ10  + answer.answ15
      vigor = answer.answ4 + answer.answ9 + answer.answ14
      fatiga = answer.answ3 + answer.answ8 + answer.answ13
      ansiedad_cognitiva = answer.answ19 + answer.answ22 + answer.answ25 + answer.answ28 + answer.answ31 + answer.answ34 + answer.answ37 + answer.answ40 + answer.answ43
      auto_confianza = answer.answ21 + answer.answ24 + answer.answ27 + answer.answ30 + answer.answ33 + answer.answ36 + answer.answ39 + answer.answ42 + answer.answ45
      relajado = 0
      case answer.answ32
      when 1:
        relajado = 4
      when 2:
        relajado = 3
      when 3:
        relajado = 2
      when 4:
        relajado = 1
      end
      ansiedad_somatica = answer.answ20 + answer.answ23 + answer.answ26 + answer.answ29 + relajado+ answer.answ35 + answer.answ38 + answer.answ41 + answer.answ44
      nivel_motivacion = (answer.answ46 + answer.answ47)/2.0
      nivel_dificultad = answer.answ17
      grado_confianza =  answer.answ18
      percepcion_elaboracion = (answer.answ50 + answer.answ51)/2.0

      @advice=[]
      @icon=[]
      item=0
      if tension< 5
        @advice[item]=l(:quest4_d1_a)
        @icon[item]="star"
      else
        if tension< 9
          @advice[item]=l(:quest4_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d1_c)
          @icon[item]="stop"
        end
      end
      item=1
      if depresion< 2
        @advice[item]=l(:quest4_d2_a)
        @icon[item]="star"
      else
        if depresion< 6
          @advice[item]=l(:quest4_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d2_c)
          @icon[item]="stop"
        end
      end
      item=2
      if hostilidad < 3
        @advice[item]=l(:quest4_d3_a)
        @icon[item]="star"
      else
        if hostilidad < 7
          @advice[item]=l(:quest4_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d3_c)
          @icon[item]="stop"
        end
      end
      item=3
      if vigor < 7
        @advice[item]=l(:quest4_d4_a)
        @icon[item]="stop"
      else
        if vigor < 10
          @advice[item]=l(:quest4_d4_b)
          @icon[item]="medium"
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d4_c)
          @icon[item]="star"
        end
      end
      item=4
      if fatiga < 4
        @advice[item]=l(:quest4_d5_a)
        @icon[item]="star"
      else
        if fatiga < 8
          @advice[item]=l(:quest4_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d5_c)
          @icon[item]="stop"
        end
      end
      item=5
      if ansiedad_cognitiva < 13
        @advice[item]=l(:quest4_d6_a)
        @icon[item]="star"
      else
        if ansiedad_cognitiva < 25
          @advice[item]=l(:quest4_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d6_c)
          @icon[item]="stop"
        end
      end
      item=6
      if auto_confianza < 1
        @advice[item]=l(:quest4_d7_a)
        @icon[item]="stop"
      else
        if auto_confianza < 25
          @advice[item]=l(:quest4_d7_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d7_c)
          @icon[item]="star"
        end
      end
      item=7
      if ansiedad_somatica < 13
        @advice[item]=l(:quest4_d8_a)
        @icon[item]="star"
      else
        if ansiedad_somatica < 25
          @advice[item]=l(:quest4_d8_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d8_c)
          @icon[item]="stop"
        end
      end
      item=8
      if nivel_motivacion < 60
        @advice[item]=l(:quest4_d9_a)
        @icon[item]="stop"
      else
        if nivel_motivacion <= 80
          @advice[item]=l(:quest4_d9_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d9_c)
          @icon[item]="star"
        end
      end
      item=9
      if nivel_dificultad < 60
        @advice[item]=l(:quest4_d10_a)
        @icon[item]="star"
      else
        if nivel_dificultad <= 80
          @advice[item]=l(:quest4_d10_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d10_c)
          @icon[item]="stop"
        end
      end
      item=10
      if grado_confianza < 60
        @advice[item]=l(:quest4_d11_a)
        @icon[item]="stop"
      else
        if grado_confianza <= 80
          @advice[item]=l(:quest4_d11_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d11_c)
          @icon[item]="star"
        end
      end
      item=11
      if percepcion_elaboracion < 60
        @advice[item]=l(:quest4_d12_a)
        @icon[item]="stop"
      else
        if percepcion_elaboracion <= 80
          @advice[item]=l(:quest4_d12_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest4_d12_c)
          @icon[item]="star"
        end
      end

      tTransformada=tVal[tension]
      dTransformada=dVal[depresion]
      hTransformada=hVal[hostilidad]
      vTransformada=vVal[vigor]
      fTransformada=fVal[fatiga]
      acTransformada=ansiedad_cognitiva+36
      atTransformada=auto_confianza+36
      asTransformada=ansiedad_somatica+36

      strXML = strXML + "<dataset SeriesName='"
      if answer.id == @id
        strXML = strXML+l(:quest1_label_10)+"' lineThickness='4' "
      else
        strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))+"' anchorSides='4' lineThickness='2' "
      end
      strXML = strXML +" renderAs='Line' >"
      strXML = strXML + "<set value='" + tTransformada + "'/>"
      strXML = strXML + "<set value='" + dTransformada + "'/>"
      strXML = strXML + "<set value='" + hTransformada + "'/>"
      strXML = strXML + "<set value='" + vTransformada + "'/>"
      strXML = strXML + "<set value='" + fTransformada + "'/>"
      strXML = strXML + "<set value='" + acTransformada.to_s + "'/>"
      strXML = strXML + "<set value='" + atTransformada.to_s + "'/>"
      strXML = strXML + "<set value='" + asTransformada.to_s + "'/>"
      strXML = strXML + "</dataset>"
    end
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest4_label_0)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest4_label_11)+"' value='"+acorta(nivel_motivacion)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_12)+"' value='"+nivel_dificultad.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_13)+"' value='"+grado_confianza.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_14)+"' value='"+acorta(percepcion_elaboracion)+"'/>"
    strXML = strXML + "</chart>"
    @chart2= renderChart("/charts/Column2D.swf"+l(:PBarLoadingText), "", strXML, "quest4_2", 450, 300, false, false)
  end
end
