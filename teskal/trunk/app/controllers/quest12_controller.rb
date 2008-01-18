class Quest12Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    new_quest
  end

  def show
    show_quest
    teskalChart12
  end


  def teskalChart12
    @advice=[]
    @icon=[]

    #strXML will be used to store the entire XML document generated
    strXML=''

    #Generate the chart element
    if @answers.length > 1
      strXML = "<chart palette='2' caption='"+l(:quest12_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'  numDivLines='4' bgcolor='ffffff' borderColor='ffffff'>"
      strXML = strXML + "<categories>"
      strXML = strXML + "<category label= '"+l(:quest12_label_1)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest12_label_2 )+"'/>"
      strXML = strXML + "</categories>"
    else
      strXML = "<chart caption='"+l(:quest12_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    end

    for answer in @answers
      clima_rendimiento = (answer.answ1 + answer.answ2 + answer.answ5 + answer.answ6 + answer.answ9 + answer.answ12)/6.0
      clima_rendimiento = clima_rendimiento/10.0
      clima_maestria = (answer.answ3 + answer.answ4 + answer.answ7 + answer.answ8 + answer.answ10 + answer.answ11)/6.0
      clima_maestria = clima_maestria/10.0

      if @answers.length > 1
        strXML = strXML +"<dataset SeriesName='"
        if answer.id == @id
          strXML = strXML+l(:quest3_label_10)
          strXML = strXML+"' renderAs='Bar' >"
        else
          strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))
          strXML = strXML+"' lineThickness='2' renderAs='Line' >"
        end
        strXML = strXML + "<set value='" + acorta(clima_rendimiento) + "'/>"
        strXML = strXML + "<set value='" + acorta(clima_maestria) + "'/>"
        strXML = strXML + "</dataset>"
      else
        strXML = strXML + "<set label='" + l(:quest12_label_1) + "' value='" + acorta(clima_rendimiento) + "'/>"
        strXML = strXML + "<set label='" + l(:quest12_label_2) + "' value='" + acorta(clima_maestria) + "'/>"
      end
    end
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    if @answers.length > 1
      @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest12", 480, 300, false, false)
    else
      @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest12", 600, 185, false, false)
    end
    
    item=0
    if clima_rendimiento < 4
      @advice[item]=l(:quest12_d1_a)
      @icon[item]="star"
    else
      if clima_rendimiento <= 7
        @advice[item]=l(:quest12_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest12_d1_c)
        @icon[item]="stop"
      end
    end
    item=1
    if clima_maestria < 4
      @advice[item]=l(:quest12_d2_a)
      @icon[item]="stop"
    else
      if clima_maestria <= 7
        @advice[item]=l(:quest12_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest12_d2_c)
        @icon[item]="star"
      end
    end
    
  end
end
