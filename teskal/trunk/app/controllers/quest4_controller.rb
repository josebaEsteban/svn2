class Quest4Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end
  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=4
    @answer.user_id=session[:user_id]
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      redirect_to :action => 'show', :id => @answer.id

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
    ansiedadSomatica = @answer.answ20 + @answer.answ23 + @answer.answ26 + @answer.answ29 + @answer.answ32+ @answer.answ35 + @answer.answ38 + @answer.answ41 + @answer.answ44
    nivelMotivacion = (@answer.answ46 + @answer.answ47)/2
    nivelDificultad = @answer.answ17
    gradoConfianza =  @answer.answ18
    percepcionElaboracion = (@answer.answ50 + @answer.answ51)/2

    @advice=[]
    if tension< 5
      @advice[0]=l(:quest1_d1_a)
    else
      if tension< 9
        @advice[0]=l(:quest1_d1_b)
      else
        @advice[0]=l(:quest1_d1_c)
      end
    end
    if depresion< 2
      @advice[1]=l(:quest1_d2_a)
    else
      if depresion< 6
        @advice[1]=l(:quest1_d2_b)
      else
        @advice[1]=l(:quest1_d2_c)
      end
    end
    if hostilidad < 3
      @advice[2]=l(:quest1_d3_a)
    else
      if hostilidad < 7
        @advice[2]=l(:quest1_d3_b)
      else
        @advice[2]=l(:quest1_d3_c)
      end
    end
    if vigor < 7
      @advice[3]=l(:quest1_d4_a)
    else
      if vigor < 10
        @advice[3]=l(:quest1_d4_b)
      else
        @advice[3]=l(:quest1_d4_c)
      end
    end
    if fatiga < 4
      @advice[4]=l(:quest1_d5_a)
    else
      if fatiga < 8
        @advice[4]=l(:quest1_d5_b)
      else
        @advice[4]=l(:quest1_d5_c)
      end
    end
    if ansiedadCognitiva < 13
      @advice[5]=l(:quest1_d6_a)
    else
      if ansiedadCognitiva < 25
        @advice[5]=l(:quest1_d6_b)
      else
        @advice[5]=l(:quest1_d6_c)
      end
    end
    if autoConfianza < 13
      @advice[6]=l(:quest1_d7_a)
    else
      if autoConfianza < 25
        @advice[6]=l(:quest1_d7_b)
      else
        @advice[6]=l(:quest1_d7_c)
      end
    end
    if ansiedadSomatica < 13
      @advice[7]=l(:quest1_d8_a)
    else
      if ansiedadSomatica < 25
        @advice[7]=l(:quest1_d8_b)
      else
        @advice[7]=l(:quest1_d8_c)
      end
    end
    if nivelMotivacion < 60
      @advice[8]=l(:quest4_d9_a)
    else
      if nivelMotivacion <= 80
        @advice[8]=l(:quest4_d9_b)
      else
        @advice[8]=l(:quest4_d9_c)
      end
    end
    if nivelDificultad < 60
      @advice[9]=l(:quest4_d10_a)
    else
      if nivelDificultad <= 80
        @advice[9]=l(:quest4_d10_b)
      else
        @advice[9]=l(:quest4_d10_c)
      end
    end
    if gradoConfianza < 60
      @advice[10]=l(:quest4_d11_a)
    else
      if gradoConfianza <= 80
        @advice[10]=l(:quest4_d11_b)
      else
        @advice[10]=l(:quest4_d11_c)
      end
    end
    if percepcionElaboracion < 60
      @advice[11]=l(:quest4_d12_a)
    else
      if percepcionElaboracion <= 80
        @advice[11]=l(:quest4_d12_b)
      else
        @advice[11]=l(:quest4_d12_c)
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
    strXML = "<chart palette='2' caption='"+l(:quest4)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    @chart1= renderChart("/charts/MSCombi2D.swf", "", strXML, "quest3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:quest4_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:quest4_label_11)+"' value='"+nivelMotivacion.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_12)+"' value='"+nivelDificultad.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_13)+"' value='"+gradoConfianza.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:quest4_label_14)+"' value='"+percepcionElaboracion.to_s+"'/>"
    strXML = strXML + "</chart>"
    @chart2= renderChart("/charts/Column2D.swf", "", strXML, "quest4_2", 450, 300, false, false)
  end
end
