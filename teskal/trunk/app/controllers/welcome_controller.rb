# Copyright (C)2007  Teskal


class WelcomeController < ApplicationController
  layout 'base'
  skip_before_filter :check_if_login_required, :only => [:signup_done, :index, :lost_email_sent, :chart1, :chart2, :chart3, :chart4, :chart5, :chart6]
  def index

    # @projects = Project.laquest logged_in_user
    # @answers = Answer.find_by_user_id('21')
    # redirect_to :controller => 'account', :action => 'login'
  end

  def chart1
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest1_label_30)+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    strXML = strXML + "<dataset SeriesName='"
    strXML = strXML+l(:quest1_label_10)+"' lineThickness='4' "
    strXML = strXML +" renderAs='Line' >"
    strXML = strXML + "<set value='38'/><set value='56'/><set value='45'/><set value='41'/><set value='59'/><set value='59'/><set value='60'/><set value='59'/>"
    strXML = strXML + "</dataset>"
    strXML = strXML + "</chart>"
    @chart= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 600, 250, false, false)
  end

  def chart2
    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_31)+"'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' >"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:quest1_label_18)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_19)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_20)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_21)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_22)+"' color='b23f3f'>"
    strXML = strXML +"<set value='70' /><set value='80' /><set value='90' /><set value='50' /></dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_23)+"' renderAs='Area' color='759a0c'>"
    strXML = strXML + "<set value='50' /><set value='30' /><set value='100' /><set value='70' /></dataset> </chart>"
    @chart = renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_2", 610, 300, false, false)
  end

  def chart3
    strXML=''
    strXML = "<chart palette='2' caption='"+l(:quest3_label_0)+"' xAxisName='"+l_datetime(Time.now)+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'   bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    strXML = strXML +"<dataset SeriesName='01/18/2008 10:11 PM' anchorSides='4' lineThickness='1'  renderAs='Line' ><set value='49'/><set value='67'/><set value='49'/><set value='51'/><set value='52'/><set value='51'/><set value='51'/><set value='45'/></dataset>"
    strXML = strXML + "<dataset SeriesName='"+l_datetime(Time.now-1000000)+"' lineThickness='4'  renderAs='Line' ><set value='57'/><set value='67'/><set value='63'/><set value='44'/><set value='52'/><set value='57'/><set value='48'/><set value='57'/></dataset></chart>"
    @chart = renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)
  end

  def chart4
    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_32)+"' xAxisName='"+l_datetime(Time.now)+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest1_label_13)+"' value='5.0'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_14)+"' value='7.5'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_15)+"' value='7.5'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_16)+"' value='3.66'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_17)+"' value='10.0'/>"
    strXML = strXML + "</chart>"
    @chart = renderChart("/charts/Column2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_3", 610, 300, false, false)
  end

  def chart5
    strXML = "<chart caption='"+l(:quest8_label_0)+"' yAxisName='"+l_datetime(Time.now)+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest8_label_1) + "' value='6.66'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_2) + "' value='10.0'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_4) + "' value='6.85'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_5) + "' value='6.19'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_6) + "' value='8.85'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_7) + "' value='7.14'/>"
    strXML = strXML + "<set label='' value=''/>"
    strXML = strXML + "<set label='" + l(:quest8_label_3) + "' value='9.52'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_8) + "' value='3.33'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_9) + "' value='2.85'/>"
    strXML = strXML + "<set label='" + l(:quest8_label_10) + "' value='5.71'/>"
    strXML = strXML + "</chart>"
    @chart= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest8", 600, 375, false, false)
  end

  def chart6
    strXML = "<chart palette='2' caption='"+l(:quest12_label_0)+"' xAxisName='"+l_datetime(Time.now)+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'  numDivLines='4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<categories>"
    strXML = strXML + "<category label= '"+l(:quest12_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest12_label_2 )+"'/>"
    strXML = strXML + "</categories>"
    strXML = strXML + "<dataset SeriesName='"+l_datetime(Time.now-1000000)+"' lineThickness='2' renderAs='Line' ><set value='2.33'/><set value='2.66'/></dataset>"
    strXML = strXML + "<dataset SeriesName='"+l_datetime(Time.now-2000000)+"' lineThickness='2' renderAs='Line' ><set value='3.5'/><set value='2.66'/></dataset>"
    strXML = strXML + "<dataset SeriesName='"+l_datetime(Time.now-4000000)+"' lineThickness='2' renderAs='Line' ><set value='4.66'/><set value='4.83'/></dataset>"
    strXML = strXML + "<dataset SeriesName='"+l_datetime(Time.now-6000000)+"' lineThickness='2' renderAs='Line' ><set value='8.5'/><set value='3.16'/></dataset>"
    strXML = strXML +  "<dataset SeriesName='"+l(:quest3_label_10)+"' renderAs='Bar' ><set value='1.66'/><set value='8.33'/></dataset></chart>"
    @chart= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest12", 480, 300, false, false)
  end

  def signup_done
  end

  def lost_email_sent
  end

end
