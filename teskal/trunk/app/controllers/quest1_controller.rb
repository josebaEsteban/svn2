class Quest1Controller < ApplicationController
  layout 'base'
  before_filter :require_login, :require_suscription

  def new
    user=User.find(session[:user_id])
    user.start = Time.now
    user.save
    if !params[:id].nil?
      user.filled_for = params[:id]
    else
      user.filled_for = session[:user_id]
    end
  end 
  
  def create
    @answer = Answer.new(params[:answer])
    @answer.ip = request.remote_ip
    @answer.quest_id=1
    @answer.user_id=session[:user_id]
    user=User.find(session[:user_id])
    @answer.time_to_fill =  Time.now - user.start
    if @answer.answ24.nil?
      @answer.answ24=0
    end
    if @answer.answ25.nil?
      @answer.answ25=0
    end
    if user.show?
      @answer.browse = 1
    end
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest1/create/"+@answer.id.to_s, @answer.user_id) 
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
    TzTime.zone=@user.timezone
    journal( "quest1/show/"+@answer.id.to_s, @answer.user_id) 
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart1
  end

  def teskalChart1

    # Transformadas
    tVal = %w(36 36 38 42 46 49 53 57 60 64 68 71 75)
    dVal = %w(41 45 49 52 56 60 64 67 71 75 79 79 79)
    hVal = %w(38 42 45 49 53 56 60 63 67 70 74 77 79)
    vVal = %w(36 36 36 37 41 44 48 51 55 59 62 66 69)
    fVal = %w(36 39 42 45 49 52 55 59 62 65 68 72 75)

    tension = @answer.answ1 + @answer.answ6  + @answer.answ11
    depresion = @answer.answ2 + @answer.answ7 + @answer.answ12
    hostilidad = @answer.answ5 + @answer.answ10  + @answer.answ15
    vigor = @answer.answ4 + @answer.answ9 + @answer.answ14
    fatiga = @answer.answ3 + @answer.answ8 + @answer.answ13
    ansiedadCognitiva = @answer.answ26 + @answer.answ29 + @answer.answ32 + @answer.answ35 + @answer.answ38 + @answer.answ41 + @answer.answ44 + @answer.answ47 + @answer.answ50
    autoConfianza = @answer.answ28 + @answer.answ31 + @answer.answ34 + @answer.answ37 + @answer.answ40 + @answer.answ43 + @answer.answ46 + @answer.answ49 + @answer.answ52
    ansiedadSomatica = @answer.answ27 + @answer.answ30 + @answer.answ33 + @answer.answ36 + @answer.answ39 + @answer.answ42 + @answer.answ45 + @answer.answ48 + @answer.answ51
    dificultad = (@answer.answ59 + @answer.answ61 + @answer.answ63 + @answer.answ65)/4
    confianza = (@answer.answ60 + @answer.answ62 + @answer.answ64 + @answer.answ66)/4
    autoControl = ((@answer.answ16 + @answer.answ17) /2) *2.5
    visionado = ((@answer.answ18 + @answer.answ19 + @answer.answ20) /3) *2.5
    autoMotivacion = ((@answer.answ21 + @answer.answ22 + @answer.answ23) /3) *2.5
    ego = ((@answer.answ53 + @answer.answ54 + @answer.answ57 + @answer.answ58 + @answer.answ61 + @answer.answ64) /6.0) /10.0
    ot = ((@answer.answ55 + @answer.answ56 + @answer.answ59 + @answer.answ60 + @answer.answ62 + @answer.answ63) /6.0) /10.0

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
    if ansiedadCognitiva < 13
      @advice[item]=l(:quest1_d6_a)
      @icon[item]="star"
    else
      if ansiedadCognitiva < 25
        @advice[item]=l(:quest1_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest1_d6_c)
        @icon[item]="stop"
      end
    end
    item=6
    if autoConfianza < 13
      @advice[item]=l(:quest1_d7_a)
      @icon[item]="stop"
    else
      if autoConfianza < 25
        @advice[item]=l(:quest1_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest1_d7_c)
        @icon[item]="star"
      end
    end
    item=7
    if ansiedadSomatica < 13
      @advice[item]=l(:quest1_d8_a)
      @icon[item]="star"
    else
      if ansiedadSomatica < 25
        @advice[item]=l(:quest1_d8_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest1_d8_c)
        @icon[item]="stop"
      end
    end
    item=8
    if dificultad < 60
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
    if confianza < 60
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
    if autoControl < 4
      @advice[item]=l(:quest1_d11_a)
      @icon[item]="stop"
    else
      if autoControl <= 7
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
    if autoMotivacion < 4
      @advice[item]=l(:quest1_d13_a)
      @icon[item]="stop"
    else
      if autoMotivacion <= 7
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
      @icon[item]="stop"
    else
      if ego <= 7
        @advice[item]=l(:quest1_d14_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest1_d14_c)
        @icon[item]="star"
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
    acTransformada=ansiedadCognitiva+36
    atTransformada=autoConfianza+36
    asTransformada=ansiedadSomatica+36

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest1_label_30)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_9)+"' lineThickness='3' renderAs='Line' >"
    strXML = strXML +"<set value='42' /><set value='37' /><set value='40' /><set value='68' /><set value='38' /><set value='42' /><set value='68' /><set value='38' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_10)+"' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "<set value='" + tTransformada + "'/>"
    strXML = strXML + "<set value='" + dTransformada + "'/>"
    strXML = strXML + "<set value='" + hTransformada + "'/>"
    strXML = strXML + "<set value='" + vTransformada + "'/>"
    strXML = strXML + "<set value='" + fTransformada + "'/>"
    strXML = strXML + "<set value='" + acTransformada.to_s + "'/>"
    strXML = strXML + "<set value='" + atTransformada.to_s + "'/>"
    strXML = strXML + "<set value='" + asTransformada.to_s + "'/>"
    strXML = strXML + "</dataset> </chart>"

    #Create the chart
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_31)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' >"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:quest1_label_18)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_19)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_20)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest1_label_21)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_22)+"' color='b23f3f'>"
    strXML = strXML +"<set value='"+@answer.answ66.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ68.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ70.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ72.to_s+"' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest1_label_23)+"' renderAs='Area' color='759a0c'>"
    strXML = strXML +"<set value='"+@answer.answ67.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ69.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ71.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ73.to_s+"' />"
    strXML = strXML + "</dataset> </chart>"
    @chart2= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_2", 450, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest1_label_32)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest1_label_13)+"' value='"+acorta(autoControl)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_14)+"' value='"+acorta(visionado)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_15)+"' value='"+acorta(autoMotivacion)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_16)+"' value='"+acorta(ego)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest1_label_17)+"' value='"+acorta(ot)+"'/>"
    strXML = strXML + "</chart>"
    @chart3= renderChart("/charts/Column2D.swf"+l(:PBarLoadingText), "", strXML, "quest3_3", 450, 300, false, false)
  end
end
