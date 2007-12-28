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

  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=11
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
      if user.show?
        @answer.browse = true
      end
    else
      @answer.user_id = user.filled_for
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    if @answer.save
      journal( "quest11/create/"+@answer.id.to_s, @answer.user_id)
      # pendings = Pending.find_by_sql("select id from pendings where pendings.user_id=#{@answer.user_id} and pendings.quest_id=#{@answer.quest_id} order by pendings.created_on ASC")
      # if pendings.length >0
      #   Pending.delete(pendings[0])
      # end

      quest = Quest.find(:first, :conditions  => {:user_id  => @answer.user_id, :order => 11})
      quest.toggle!(:browse)

      if user.show?
        redirect_to :action => 'show', :id => @answer.id
      else
        redirect_to :controller  => 'my', :action  => 'page'
      end

      # format.html { redirect_to answer_url(@answer) }
      # format.xml  { head :created, :location => answer_url(@answer) }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @answer.errors.to_xml }
    end
  end

  def show
    @answer = Answer.find(params[:id])
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest11/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskal_chart11
  end


  def teskal_chart11
    scale=10/7.0
    valor_bajo = 3 * scale
    valor_medio = 5 * scale
    @advice=[]
    @icon=[]

    know = ((@answer.answ2 + @answer.answ5 + @answer.answ26 + @answer.answ30)/4.0 ) * scale
    accomplish = ((@answer.answ9 + @answer.answ13 + @answer.answ16 + @answer.answ22)/4.0 ) * scale
    experience = ((@answer.answ1 + @answer.answ14 + @answer.answ20 + @answer.answ28)/4.0 ) * scale
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
    integrated_regulation = ((@answer.answ4 + @answer.answ18 + @answer.answ24 + @answer.answ31)/4.0 ) * scale
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
    identified_regulation = ((@answer.answ8 + @answer.answ12 + @answer.answ19 + @answer.answ27)/4.0 ) * scale
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
    introjected_regulation = ((@answer.answ10 + @answer.answ15 + @answer.answ23 + @answer.answ29)/4.0 ) * scale
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
    motivacion_extrinseca = ((@answer.answ7 + @answer.answ11 + @answer.answ17 + @answer.answ25)/4.0 ) * scale
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
    amotivation = ((@answer.answ3 + @answer.answ6 + @answer.answ21 + @answer.answ32)/4.0 ) * scale
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

    #strXML will be used to store the entire XML document generated
    strXML=''

    # before scaling to base 10
    # yAxisMaxValue='7'

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

    strXML = "<chart caption='"+l(:quest11_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='10' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label='" + l(:quest11_label_1) + "' value='" + acorta(motivacion_intrinseca) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_2) + "' value='" + acorta(integrated_regulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_3) + "' value='" + acorta(identified_regulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_4) + "' value='" + acorta(introjected_regulation) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_5) + "' value='" + acorta(motivacion_extrinseca) + "'/>"
    strXML = strXML + "<set label='" + l(:quest11_label_6) + "' value='" + acorta(amotivation) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest8", 600, 300, false, false)
  end
end
