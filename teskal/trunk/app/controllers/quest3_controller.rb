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

  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=3
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
    else
      @answer.user_id = user.filled_for
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    if @answer.answ24.nil?
      @answer.answ24=0
    end
    if @answer.answ25.nil?
      @answer.answ25=0
    end
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest3/create/"+@answer.id.to_s, @answer.user_id)
      pendings = Pending.find_by_sql("select id from pendings where pendings.user_id=#{@answer.user_id} and pendings.quest_id=#{@answer.quest_id} order by pendings.created_on ASC")
      if pendings.length >0
        Pending.delete(pendings[0])
      end
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
    @fecha = l_datetime(@answer.created_on)
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest3/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart3
  end


  def teskalChart3
    # transformadas
    tVal = %w(36 36 38 42 46 49 53 57 60 64 68 71 75)
    dVal = %w(41 45 49 52 56 60 64 67 71 75 79 79 79)
    hVal = %w(38 42 45 49 53 56 60 63 67 70 74 77 79)
    vVal = %w(36 36 36 37 41 44 48 51 55 59 62 66 69)
    fVal = %w(36 39 42 45 49 52 55 59 62 65 68 72 75)

    @answer = Answer.find(params[:id])
    @user=User.find(@answer.user_id )
    # calculo de las dimensiones

    tension = @answer.answ1 + @answer.answ6  + @answer.answ11
    depresion = @answer.answ2 + @answer.answ7 + @answer.answ12
    hostilidad = @answer.answ5 + @answer.answ10 + @answer.answ15
    vigor = @answer.answ4 + @answer.answ9 + @answer.answ14
    fatiga = @answer.answ3 + @answer.answ8 + @answer.answ13
    compromisoEsfuerzo = ((@answer.answ16 + @answer.answ19 + @answer.answ22)*3.0).round
    ansiedadErrores = ((@answer.answ18 + @answer.answ21 + @answer.answ24)*3.0).round
    competenciaPercibida = ((@answer.answ17 + @answer.answ20 + @answer.answ23)*3.0).round

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
    if compromisoEsfuerzo < 13
      @advice[item]=l(:quest3_d6_a)
      @icon[item]="stop"
    else
      if compromisoEsfuerzo < 25
        @advice[item]=l(:quest3_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest3_d6_c)
        @icon[item]="star"
      end
    end
    item=6
    if ansiedadErrores < 13
      @advice[item]=l(:quest3_d7_a)
      @icon[item]="star"
    else
      if ansiedadErrores < 25
        @advice[item]=l(:quest3_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest3_d7_c)
        @icon[item]="stop"
      end
    end
    item=7
    if competenciaPercibida < 13
      @advice[item]=l(:quest3_d8_a)
      @icon[item]="stop"
    else
      if competenciaPercibida < 25
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
    ceTrans=compromisoEsfuerzo+36
    aeTrans=ansiedadErrores+36
    cpTrans=competenciaPercibida+36

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest3_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'   bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    strXML = strXML + "<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Line' >"
    strXML = strXML + "<set value='40' /><set value='36' /><set value='40' /><set value='70' /><set value='38' /><set value='70' /><set value='38' /><set value='70' />"
    strXML = strXML + "</dataset>"
    strXML = strXML + "<dataset SeriesName='"+l(:quest3_label_10)+"' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "<set value='" + tTrans + "'/>"
    strXML = strXML + "<set value='" + dTrans + "'/>"
    strXML = strXML + "<set value='" + hTrans + "'/>"
    strXML = strXML + "<set value='" + vTrans + "'/>"
    strXML = strXML + "<set value='" + fTrans + "'/>"
    strXML = strXML + "<set value='" + ceTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + aeTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + cpTrans.to_s + "'/>"
    strXML = strXML + "</dataset> </chart>"
    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)
  end
end
