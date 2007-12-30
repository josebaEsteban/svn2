class Quest6Controller < ApplicationController
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
    @answer = Answer.find(params[:id])
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest6/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart6
  end

  def teskalChart6
    scale=10/25.0
    # calculo de las dimensiones

    rg = (@answer.answ1 + @answer.answ2  + @answer.answ3 + @answer.answ4 + @answer.answ5)
    it =  (@answer.answ6 + @answer.answ7 + @answer.answ8 + @answer.answ9 + @answer.answ10)
    ct = (@answer.answ11 + @answer.answ12 + @answer.answ13 + @answer.answ14 + @answer.answ15)
    rp = (@answer.answ16 + @answer.answ17 + @answer.answ18 + @answer.answ19 + @answer.answ20)
    cl = rg + it + ct + rp
    ctt = @answer.answ21
    x = (cl + ctt) / 2
    y = (cl - ctt).abs

    @advice=[]
    @icon=[]
    item=0
    if rg < 14
      @advice[item]=l(:quest6_d1_a)
      @icon[item]="stop"
    else
      if rg < 20
        @advice[item]=l(:quest6_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest6_d1_c)
        @icon[item]="star"
      end
    end
    item=1
    if rp < 14
      @advice[item]=l(:quest6_d2_a)
      @icon[item]="stop"
    else
      if rp < 20
        @advice[item]=l(:quest6_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest6_d2_c)
        @icon[item]="star"
      end
    end
    item=2
    if ct < 14
      @advice[item]=l(:quest6_d3_a)
      @icon[item]="stop"
    else
      if ct < 20
        @advice[item]=l(:quest6_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest6_d3_c)
        @icon[item]="star"
      end
    end
    item=3
    if it < 14
      @advice[item]=l(:quest6_d4_a)
      @icon[item]="stop"
    else
      if it < 20
        @advice[item]=l(:quest6_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest6_d4_c)
        @icon[item]="star"
      end
    end
    item=4
    case
    when x < 60
      @icon[item]="stop"
      case
      when y < 15
        @advice[item]=l(:quest5_val_g)
      when y < 30
        @advice[item]=l(:quest5_val_h)
      else
        @advice[item]=l(:quest5_val_i)
      end
    when x < 80
      @icon[item]="medium"
      case
      when y < 15
        @advice[item]=l(:quest5_val_d)
      when y < 30
        @advice[item]=l(:quest5_val_e)
      else
        @advice[item]=l(:quest5_val_f)
      end
    else
      @icon[item]="star"
      case
      when y < 15
        @advice[item]=l(:quest5_val_a)
      when y < 30
        @advice[item]=l(:quest5_val_b)
      else
        @advice[item]=l(:quest5_val_c)
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''

    # before scaling to base 10
    # yAxisMaxValue='25'

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest6_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showvalues='0'  PYAxisName='Comarcas' formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest6_label_1) + "' value= '" + (rg * scale).to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest6_label_2) + "' value= '" + (rp * scale).to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest6_label_3) + "' value= '" + (ct * scale).to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest6_label_4) + "' value= '" + (it * scale).to_s + "'/>"
    strXML = strXML + "</chart>"
    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest5", 550, 270, false, false)
  end
end
