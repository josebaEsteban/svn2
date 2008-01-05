class Quest7Controller < ApplicationController
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
    teskalChart7
  end


  def teskalChart7
    scale=10/7.0
    # calculo de las dimensiones

    #strXML will be used to store the entire XML document generated
    strXML=''

    # before scaling to base 10
    # yAxisMaxValue='6'

    #Generate the chart element
    if @answers.length > 1
      strXML = "<chart palette='2' caption='"+l(:quest7_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'  numDivLines='4' bgcolor='ffffff' borderColor='ffffff'>"
      strXML = strXML +"<categories>"
      strXML = strXML + "<category label= '"+l(:quest7_label_1)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest7_label_2)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest7_label_3)+"'/>"
      # strXML = strXML + "<category label= ''/>"
      strXML = strXML + "<category label= '"+l(:quest7_label_4)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest7_label_5)+"'/>"
      strXML = strXML + "<category label= '"+l(:quest7_label_6)+"'/>"
      strXML = strXML +"</categories>"
    else
      strXML = "<chart caption='"+l(:quest7_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    end

    for answer in @answers
      rg = (( answer.answ1 + answer.answ2  + answer.answ3 )/3.0 )
      uc = (( answer.answ4 + answer.answ5 + answer.answ6 )/3.0 )
      fe = (( answer.answ13 + answer.answ14 + answer.answ15 )/3.0 )
      dp = (( answer.answ16 + answer.answ17 + answer.answ18  )/3.0 )
      ei = (( answer.answ10 + answer.answ11 + answer.answ12 )/3.0 )
      tp = (( answer.answ7 + answer.answ8 + answer.answ9 )/3.0 )

      @advice=[]
      @icon=[]
      item=0
      if rg < 3
        @advice[item]=l(:quest7_d1_a)
        @icon[item]="stop"
      else
        if rg < 5
          @advice[item]=l(:quest7_d1_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d1_c)
          @icon[item]="star"
        end
      end
      item=1
      if dp < 3
        @advice[item]=l(:quest7_d2_a)
        @icon[item]="stop"
      else
        if dp < 5
          @advice[item]=l(:quest7_d2_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d2_c)
          @icon[item]="star"
        end
      end
      item=2
      if fe < 3
        @advice[item]=l(:quest7_d3_a)
        @icon[item]="stop"
      else
        if fe < 5
          @advice[item]=l(:quest7_d3_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d3_c)
          @icon[item]="star"
        end
      end
      item=3
      if uc < 3
        @advice[item]=l(:quest7_d4_a)
        @icon[item]="stop"
      else
        if uc < 5
          @advice[item]=l(:quest7_d4_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d4_c)
          @icon[item]="star"
        end
      end
      item=4
      if ei < 3
        @advice[item]=l(:quest7_d5_a)
        @icon[item]="stop"
      else
        if ei < 5
          @advice[item]=l(:quest7_d5_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d5_c)
          @icon[item]="star"
        end
      end
      item=5
      if tp < 3
        @advice[item]=l(:quest7_d6_a)
        @icon[item]="stop"
      else
        if tp < 5
          @advice[item]=l(:quest7_d6_b)
          @icon[item]="medium"
        else
          @advice[item]=l(:quest7_d6_c)
          @icon[item]="star"
        end
      end

      # before scaling to base 10
      # yAxisMaxValue='7'
      if @answers.length > 1
        strXML = strXML +"<dataset SeriesName='"
        if answer.id == @id
          strXML = strXML+l(:quest3_label_10)
          strXML = strXML+"' renderAs='Bar' >"
        else
          strXML = strXML+l_datetime(TzTime.zone.utc_to_local(answer.created_on))
          strXML = strXML+"' lineThickness='2' renderAs='Line' >"
        end
        strXML = strXML + "<set value='" + acorta(rg * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(dp * scale).to_s + "'/>"
        strXML = strXML + "<set value='" + acorta(fe * scale).to_s + "'/>"
        # strXML = strXML + "<set value=''/>"
        strXML = strXML + "<set value='" +  acorta(uc * scale).to_s + "'/>"
        strXML = strXML + "<set value='" +  acorta(ei * scale).to_s + "'/>"
        strXML = strXML + "<set value='" +  acorta(tp * scale).to_s + "'/>"
        strXML = strXML + "</dataset>"
      else
        strXML = strXML + "<set label='" + l(:quest7_label_1) + "' value='" + acorta(rg * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest7_label_2) + "' value='" + acorta(dp * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest7_label_3) + "' value='" + acorta(fe * scale) + "'/>"
        strXML = strXML + "<set label='' value=''/>"
        strXML = strXML + "<set label='" + l(:quest7_label_4) + "' value='" + acorta(uc * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest7_label_5) + "' value='" + acorta(ei * scale) + "'/>"
        strXML = strXML + "<set label='" + l(:quest7_label_6) + "' value='" + acorta(tp * scale) + "'/>"
      end
    end
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    if @answers.length > 1
      @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest7", 780, 300, false, false)
    else
      @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest7", 550, 300, false, false)
    end
  end
end
