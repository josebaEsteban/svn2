#tolerancia al stress

class Quest2Controller < ApplicationController
  layout 'base'
  before_filter :require_login

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
    teskal_chart_2
  end

  def teskal_chart_2
    scale=10/6.0


    #strXML will be used to store the entire XML document generated
    strXML=''

    # before scaling to base 10
    # yAxisMaxValue='6'

    #Generate the chart element
    if @answers.length > 1
      strXML = "<chart palette='2' caption='"+l(:quest2_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='-10' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'  numDivLines='7' bgcolor='ffffff' borderColor='ffffff'>"
      strXML = strXML +"<categories>"
      strXML = strXML + "<category label= '"+l(:quest2_label_1)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_2)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_3)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_4)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_5)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_6)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest2_label_7)+"'/>"
      strXML = strXML +"</categories>"
    else
      strXML = "<chart caption='"+l(:quest2_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMinValue='-10' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff' numDivLines='7'>"
    end
    for answer in @answers
      # calculo de las dimensiones
      descanso_interrumpido = ((answer.answ2 + answer.answ9  + answer.answ17 + answer.answ23) /4.0)
      cansancio_emocional = ((answer.answ5 + answer.answ14 + answer.answ19 + answer.answ27) /4.0)
      vulnerabilidad_lesiones = ((answer.answ1 + answer.answ8  + answer.answ15 + answer.answ24) /4.0)
      estado_forma = ((answer.answ4 + answer.answ12 + answer.answ20 + answer.answ26) /4.0)
      logro_personal = ((answer.answ6 + answer.answ11 + answer.answ21 + answer.answ28) /4.0)
      auto_eficacia = ((answer.answ3 + answer.answ10 + answer.answ16 + answer.answ22) /4.0)
      auto_regulacion = ((answer.answ7 + answer.answ13 + answer.answ18 + answer.answ25) /4.0)

      @advice=[]
      @icon=[]
      item=0
      if descanso_interrumpido < 2
        @advice[item]=l(:quest2_d1_a)
        @icon[item]="star"
      else
        if descanso_interrumpido < 4
          @advice[item]=l(:quest2_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d1_c)
          @icon[item]="stop"
        end
      end
      item=1
      if cansancio_emocional < 2
        @advice[item]=l(:quest2_d2_a)
        @icon[item]="star"
      else
        if cansancio_emocional < 4
          @advice[item]=l(:quest2_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d2_c)
          @icon[item]="stop"
        end
      end
      item=2
      if vulnerabilidad_lesiones < 2
        @advice[item]=l(:quest2_d3_a)
        @icon[item]="star"
      else
        if vulnerabilidad_lesiones < 4
          @advice[item]=l(:quest2_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d3_c)
          @icon[item]="stop"
        end
      end
      item=3
      if estado_forma < 2
        @advice[item]=l(:quest2_d4_a)
        @icon[item]="stop"
      else
        if estado_forma < 4
          @advice[item]=l(:quest2_d4_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d4_c)
          @icon[item]="star"
        end
      end
      item=4
      if logro_personal < 2
        @advice[item]=l(:quest2_d5_a)
        @icon[item]="stop"
      else
        if logro_personal < 4
          @advice[item]=l(:quest2_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d5_c)
          @icon[item]="star"
        end
      end
      item=5
      if auto_eficacia < 2
        @advice[item]=l(:quest2_d6_a)
        @icon[item]="stop"
      else
        if auto_eficacia < 4
          @advice[item]=l(:quest2_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d6_c)
          @icon[item]="star"
        end
      end
      item=6
      if auto_regulacion < 2
        @advice[item]=l(:quest2_d7_a)
        @icon[item]="stop"
      else
        if auto_regulacion < 4
          @advice[item]=l(:quest2_d7_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest2_d7_c)
          @icon[item]="star"
        end
      end
      valoracion_general=((estado_forma+logro_personal+auto_eficacia+auto_regulacion/4.0))-((descanso_interrumpido+cansancio_emocional+vulnerabilidad_lesiones)/3.0)
      item=7
      if valoracion_general < 0
        @advice[item]=l(:quest2_val_4)
      elsif valoracion_general < 1
        @advice[item]=l(:quest2_val_3)
      elsif valoracion_general < 3
        @advice[item]=l(:quest2_val_2)
      else
        @advice[item]=l(:quest2_val_1)
      end
      if @answers.length > 1
        strXML = strXML +"<dataset SeriesName='"+l_datetime(TzTime.zone.utc_to_local(answer.created_on))
        if answer.id == @id
          strXML = strXML+"' renderAs='Bar' >"
        else
          strXML = strXML+"' lineThickness='2' renderAs='Line' >"
        end
        strXML = strXML + "<set value='-" + acorta(descanso_interrumpido * scale)  + "'/>"
        strXML = strXML + "<set value='-" + acorta(cansancio_emocional * scale)  + "'/>"
        strXML = strXML + "<set value='-" + acorta(vulnerabilidad_lesiones * scale)+ "'/>"
        strXML = strXML + "<set value='" + acorta(estado_forma * scale) + "'/>"
        strXML = strXML + "<set value='" + acorta(logro_personal * scale) + "'/>"
        strXML = strXML + "<set value='" + acorta(auto_eficacia * scale) + "'/>"
        strXML = strXML + "<set value='" + acorta(auto_regulacion * scale) + "'/>"
        strXML = strXML + "</dataset>"
      else
        strXML = strXML + "<set label='" + l(:quest2_label_1) + "' value='-" + acorta(descanso_interrumpido * scale)  + "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_2) + "' value='-" + acorta(cansancio_emocional * scale)  + "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_3) + "' value='-" + acorta(vulnerabilidad_lesiones * scale)+ "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_4) + "' value='" + acorta(estado_forma * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_5) + "' value='" + acorta(logro_personal * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_6) + "' value='" + acorta(auto_eficacia * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest2_label_7) + "' value='" + acorta(auto_regulacion * scale) + "'/>"

      end
    end
    strXML = strXML + "</chart>"

    if @answers.length > 1
      #Create the chart - Pie 3D Chart with data from strXML
      @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest2", 780, 300, false, false)
    else
      @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest2", 550, 300, false, false)
    end
  end
end
