class Quest4Controller < ApplicationController
  layout 'base'
  before_filter :require_login, :require_suscription

  def new
    user=User.find(session[:user_id])
    user.start = Time.now
    if !params[:id].nil?
      user.filled_for = params[:id]
    else
      user.filled_for = session[:user_id]
    end
    user.save
  end

  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=4
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
    else
      @answer.user_id = user.filled_for
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest4/create/"+@answer.id.to_s, @answer.user_id)
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
    journal( "quest4/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart4
  end

  def teskalChart4

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
    ansiedadCognitiva = @answer.answ19 + @answer.answ22 + @answer.answ25 + @answer.answ28 + @answer.answ31 + @answer.answ34 + @answer.answ37 + @answer.answ40 + @answer.answ43
    autoConfianza = @answer.answ21 + @answer.answ24 + @answer.answ27 + @answer.answ30 + @answer.answ33 + @answer.answ36 + @answer.answ39 + @answer.answ42 + @answer.answ45
    relajado = 0
    case @answer.answ32
    when 1:
      relajado = 4
    when 2:
      relajado = 3
    when 3:
      relajado = 2
    when 4:
      relajado = 1
    end
    ansiedadSomatica = @answer.answ20 + @answer.answ23 + @answer.answ26 + @answer.answ29 + relajado+ @answer.answ35 + @answer.answ38 + @answer.answ41 + @answer.answ44
    nivelMotivacion = (@answer.answ46 + @answer.answ47)/2.0
    nivelDificultad = @answer.answ17
    gradoConfianza =  @answer.answ18
    percepcionElaboracion = (@answer.answ50 + @answer.answ51)/2.0

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
    if ansiedadCognitiva < 13
      @advice[item]=l(:quest4_d6_a)
      @icon[item]="star"
    else
      if ansiedadCognitiva < 25
        @advice[item]=l(:quest4_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d6_c)
        @icon[item]="stop"
      end
    end
    item=6
    if autoConfianza < 1
      @advice[item]=l(:quest4_d7_a)
      @icon[item]="stop"
    else
      if autoConfianza < 25
        @advice[item]=l(:quest4_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d7_c)
        @icon[item]="star"
      end
    end
    item=7
    if ansiedadSomatica < 13
      @advice[item]=l(:quest4_d8_a)
      @icon[item]="star"
    else
      if ansiedadSomatica < 25
        @advice[item]=l(:quest4_d8_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d8_c)
        @icon[item]="stop"
      end
    end
    item=8
    if nivelMotivacion < 60
      @advice[item]=l(:quest4_d9_a)
      @icon[item]="stop"
    else
      if nivelMotivacion <= 80
        @advice[item]=l(:quest4_d9_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d9_c)
        @icon[item]="star"
      end
    end
    item=9
    if nivelDificultad < 60
      @advice[item]=l(:quest4_d10_c)
      @icon[item]="star"
    else
      if nivelDificultad <= 80
        @advice[item]=l(:quest4_d10_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d10_a)
        @icon[item]="stop"
      end
    end
    item=10
    if gradoConfianza < 60
      @advice[item]=l(:quest4_d11_a)
      @icon[item]="stop"
    else
      if gradoConfianza <= 80
        @advice[item]=l(:quest4_d11_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest4_d11_c)
        @icon[item]="star"
      end
    end
    item=11
    if percepcionElaboracion < 60
      @advice[item]=l(:quest4_d12_a)
      @icon[item]="stop"
    else
      if percepcionElaboracion <= 80
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
    acTransformada=ansiedadCognitiva+36
    atTransformada=autoConfianza+36
    asTransformada=ansiedadSomatica+36

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest4_label_1)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest4_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest4_label_11)+"' value='"+acorta(nivelMotivacion)+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_12)+"' value='"+nivelDificultad.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_13)+"' value='"+gradoConfianza.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_14)+"' value='"+acorta(percepcionElaboracion)+"'/>"
    strXML = strXML + "</chart>"
    @chart2= renderChart("/charts/Column2D.swf"+l(:PBarLoadingText), "", strXML, "quest4_2", 450, 300, false, false)
  end
end
