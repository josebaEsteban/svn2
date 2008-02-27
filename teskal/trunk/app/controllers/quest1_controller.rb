class Quest1Controller < ApplicationController
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
    teskalChart1
  end

  def truncate(pele)
    inicio=""
    cuantos=pele.size
    if cuantos>4
      cuantos=4
    end
    cuantos =cuantos-1
    for i in 0..cuantos
      inicio=inicio+pele[i]+" "
    end
    inicio.chop!
    if inicio.length == 0
      inicio = " "
    end
    return inicio
  end

  def teskalChart1

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
    strXML = "<chart palette='2' caption='"+l(:quest1_label_30)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
      ansiedad_cognitiva = answer.answ26 + answer.answ29 + answer.answ32 + answer.answ35 + answer.answ38 + answer.answ41 + answer.answ44 + answer.answ47 + answer.answ50
      auto_confianza = answer.answ28 + answer.answ31 + answer.answ34 + answer.answ37 + answer.answ40 + answer.answ43 + answer.answ46 + answer.answ49 + answer.answ52
      ansiedad_somatica = answer.answ27 + answer.answ30 + answer.answ33 + answer.answ36 + answer.answ39 + answer.answ42 + answer.answ45 + answer.answ48 + answer.answ51
      media = 0
      confianza_plot=[]
      dificultad_plot=[]
      objetivo=[]
      for i in 0..3
        confianza_plot[i]=0
        dificultad_plot[i]=0
        objetivo[i]=""
      end
      truncado_a=15
      if answer.answ66 > 0 or answer.answ67 > 0
        media = media +1.0
        dificultad_plot[0]=answer.answ66
        confianza_plot[0]= answer.answ67
        pele=answer.note1.split
        objetivo[0]=truncate(pele)
      end
      if answer.answ68 > 0 or answer.answ69 > 0
        media = media +1.0
        dificultad_plot[1]=answer.answ68
        confianza_plot[1]= answer.answ69
        pele=answer.note2.split
        objetivo[1]=truncate(pele)
      end
      if answer.answ70 > 0 or answer.answ71 > 0
        media = media +1.0
        dificultad_plot[2]=answer.answ70
        confianza_plot[2]= answer.answ71
        pele=answer.note3.split
        objetivo[2]=truncate(pele)
      end
      if answer.answ72 > 0 or answer.answ73 > 0
        media = media +1.0
        dificultad_plot[3]=answer.answ72
        confianza_plot[3]= answer.answ73
        pele=answer.note4.split
        objetivo[3]=truncate(pele)
      end
      if media > 0
        dificultad = (answer.answ66 + answer.answ68 + answer.answ70 + answer.answ72)/media
        confianza = (answer.answ67 + answer.answ69 + answer.answ71 + answer.answ73)/media
      else
        dificultad = 0
        confianza = 0
      end
      auto_control = ((answer.answ16 + answer.answ17) /2) *2.5
      visionado = ((answer.answ18 + answer.answ19 + answer.answ20) /3) *2.5
      auto_motivacion = ((answer.answ21 + answer.answ22 + answer.answ23) /3) *2.5
      ego = ((answer.answ53 + answer.answ54 + answer.answ57 + answer.answ58 + answer.answ61 + answer.answ64) /6.0) /10.0
      ot = ((answer.answ55 + answer.answ56 + answer.answ59 + answer.answ60 + answer.answ62 + answer.answ63) /6.0) /10.0

      @advice=[]
      @icon=[]
      item=0
      if tension< 5
        @advice[item]=l(:quest1_d1_a)
        @icon[item]="star"
      else
        if tension< 9
          @advice[item]=l(:quest1_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d1_c)
          @icon[item]="stop"
        end
      end
      item=1
      if depresion< 2
        @advice[item]=l(:quest1_d2_a)
        @icon[item]="star"
      else
        if depresion< 6
          @advice[item]=l(:quest1_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d2_c)
          @icon[item]="stop"
        end
      end
      item=2
      if hostilidad < 3
        @advice[item]=l(:quest1_d3_a)
        @icon[item]="star"
      else
        if hostilidad < 7
          @advice[item]=l(:quest1_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d3_c)
          @icon[item]="stop"
        end
      end
      item=3
      if vigor < 7
        @advice[item]=l(:quest1_d4_a)
        @icon[item]="stop"
      else
        if vigor < 10
          @advice[item]=l(:quest1_d4_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d4_c)
          @icon[item]="star"
        end
      end
      item=4
      if fatiga < 4
        @advice[item]=l(:quest1_d5_a)
        @icon[item]="star"
      else
        if fatiga < 8
          @advice[item]=l(:quest1_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d5_c)
          @icon[item]="stop"
        end
      end
      item=5
      if ansiedad_cognitiva < 13
        @advice[item]=l(:quest1_d6_a)
        @icon[item]="star"
      else
        if ansiedad_cognitiva < 25
          @advice[item]=l(:quest1_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d6_c)
          @icon[item]="stop"
        end
      end
      item=6
      if auto_confianza < 13
        @advice[item]=l(:quest1_d7_a)
        @icon[item]="stop"
      else
        if auto_confianza < 25
          @advice[item]=l(:quest1_d7_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d7_c)
          @icon[item]="star"
        end
      end
      item=7
      if ansiedad_somatica < 13
        @advice[item]=l(:quest1_d8_a)
        @icon[item]="star"
      else
        if ansiedad_somatica < 25
          @advice[item]=l(:quest1_d8_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d8_c)
          @icon[item]="stop"
        end
      end
      item=8
      if dificultad == 0
        @advice[item]=""
        @icon[item]=""
      elsif dificultad < 60
        @advice[item]=l(:quest1_d9_a)
        @icon[item]="stop"
      else
        if dificultad < 80
          @advice[item]=l(:quest1_d9_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d9_c)
          @icon[item]="star"
        end
      end
      item=9
      if confianza == 0
        @advice[item]=""
        @icon[item]=""
      elsif confianza < 60
        @advice[item]=l(:quest1_d10_a)
        @icon[item]="stop"
      else
        if confianza < 80
          @advice[item]=l(:quest1_d10_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d10_c)
          @icon[item]="star"
        end
      end
      item=10
      if auto_control < 4
        @advice[item]=l(:quest1_d11_a)
        @icon[item]="stop"
      else
        if auto_control <= 7
          @advice[item]=l(:quest1_d11_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d11_c)
          @icon[item]="star"
        end
      end
      item=11
      if visionado < 4
        @advice[item]=l(:quest1_d12_a)
        @icon[item]="stop"
      else
        if visionado <= 7
          @advice[item]=l(:quest1_d12_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d12_c)
          @icon[item]="star"
        end
      end
      item=12
      if auto_motivacion < 4
        @advice[item]=l(:quest1_d13_a)
        @icon[item]="stop"
      else
        if auto_motivacion <= 7
          @advice[item]=l(:quest1_d13_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d13_c)
          @icon[item]="star"
        end
      end
      item=13
      if ego < 4
        @advice[item]=l(:quest1_d14_a)
        @icon[item]="star"
      else
        if ego <= 7
          @advice[item]=l(:quest1_d14_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d14_c)
          @icon[item]="stop"
        end
      end
      item=14
      if ot < 4
        @advice[item]=l(:quest1_d15_a)
        @icon[item]="stop"
      else
        if ot <= 7
          @advice[item]=l(:quest1_d15_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest1_d15_c)
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
        strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))+"' anchorSides='4' lineThickness='1' "
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

    #Create the chart
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_31)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' >"
    strXML = strXML +"<categories>"
    # strXML = strXML + "<category label= '"+l(:quest1_label_18)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest1_label_19)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest1_label_20)+"'/>"
    # strXML = strXML + "<category label= '"+l(:quest1_label_21)+"'/>"
    for i in 0..3
      if objetivo[i] !=""
        strXML = strXML + "<category label= '"+objetivo[i]+"'/>"
      end
    end
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_22)+"' color='b23f3f'>"
    for i in 0..3
      if objetivo[i] !=""
        strXML = strXML +"<set value='"+dificultad_plot[i].to_s+"' />"
      end
    end
    strXML = strXML +"</dataset>"
    if media > 1
      strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_23)+"' renderAs='Area' color='759a0c'>"
    else
      strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_23)+"' color='759a0c'>"
    end
    for j in 0..3
      if objetivo[j] !=""
        strXML = strXML +"<set value='"+confianza_plot[j].to_s+"' />"
      end
    end
    strXML = strXML + "</dataset> </chart>"
    @chart2= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_2", 610, 300, false, false)
    puts @chart2
    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_32)+"' subCaption='"+@user.name+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest1_label_13)+"' value='"+acorta(auto_control)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_14)+"' value='"+acorta(visionado)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_15)+"' value='"+acorta(auto_motivacion)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_16)+"' value='"+acorta(ego)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_17)+"' value='"+acorta(ot)+"'/>"
    strXML = strXML + "</chart>"
    @chart3= renderChart("/charts/Column2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_3", 610, 300, false, false)
  end
end
