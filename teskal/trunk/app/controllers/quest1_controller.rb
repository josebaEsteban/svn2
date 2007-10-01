class Quest1Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=1
    @answer.user_id=session[:user_id]
    if @answer.answ24.nil?
      @answer.answ24=0
    end
    if @answer.answ25.nil?
      @answer.answ25=0
    end
    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
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
    ego = ((@answer.answ53 + @answer.answ54 + @answer.answ57 + @answer.answ58 + @answer.answ61 + @answer.answ64) /6) /10
    ot = ((@answer.answ55 + @answer.answ56 + @answer.answ59 + @answer.answ60 + @answer.answ62 + @answer.answ63) /6) /10

    @advice=[]
    if tension< 5
      @advice[0]=l(:test1_d1_a)
    else
      if tension< 9
        @advice[0]=l(:test1_d1_b)
      else
        @advice[0]=l(:test1_d1_c)
      end
    end
    if depresion< 2
      @advice[1]=l(:test1_d2_a)
    else
      if depresion< 6
        @advice[1]=l(:test1_d2_b)
      else
        @advice[1]=l(:test1_d2_c)
      end
    end
    if hostilidad < 3
      @advice[2]=l(:test1_d3_a)
    else
      if hostilidad < 7
        @advice[2]=l(:test1_d3_b)
      else
        @advice[2]=l(:test1_d3_c)
      end
    end
    if vigor < 7
      @advice[3]=l(:test1_d4_a)
    else
      if vigor < 10
        @advice[3]=l(:test1_d4_b)
      else
        @advice[3]=l(:test1_d4_c)
      end
    end
    if fatiga < 4
      @advice[4]=l(:test1_d5_a)
    else
      if fatiga < 8
        @advice[4]=l(:test1_d5_b)
      else
        @advice[4]=l(:test1_d5_c)
      end
    end
    if ansiedadCognitiva < 13
      @advice[5]=l(:test1_d6_a)
    else
      if ansiedadCognitiva < 25
        @advice[5]=l(:test1_d6_b)
      else
        @advice[5]=l(:test1_d6_c)
      end
    end
    if autoConfianza < 13
      @advice[6]=l(:test1_d7_a)
    else
      if autoConfianza < 25
        @advice[6]=l(:test1_d7_b)
      else
        @advice[6]=l(:test1_d7_c)
      end
    end
    if ansiedadSomatica < 13
      @advice[7]=l(:test1_d8_a)
    else
      if ansiedadSomatica < 25
        @advice[7]=l(:test1_d8_b)
      else
        @advice[7]=l(:test1_d8_c)
      end
    end
    if dificultad < 60
      @advice[8]=l(:test1_d9_a)
    else
      if dificultad < 80
        @advice[8]=l(:test1_d9_b)
      else
        @advice[8]=l(:test1_d9_c)
      end
    end
    if confianza < 60
      @advice[9]=l(:test1_d10_a)
    else
      if confianza < 80
        @advice[9]=l(:test1_d10_b)
      else
        @advice[9]=l(:test1_d10_c)
      end
    end
    if autoControl < 4
      @advice[10]=l(:test1_d11_a)
    else
      if autoControl <= 7
        @advice[10]=l(:test1_d11_b)
      else
        @advice[10]=l(:test1_d11_c)
      end
    end
    if visionado < 4
      @advice[11]=l(:test1_d12_a)
    else
      if visionado <= 7
        @advice[11]=l(:test1_d12_b)
      else
        @advice[11]=l(:test1_d12_c)
      end
    end
    if autoMotivacion < 4
      @advice[12]=l(:test1_d13_a)
    else
      if autoMotivacion <= 7
        @advice[12]=l(:test1_d13_b)
      else
        @advice[12]=l(:test1_d13_c)
      end
    end
    if ego < 4
      @advice[13]=l(:test1_d14_a)
    else
      if ego <= 7
        @advice[13]=l(:test1_d14_b)
      else
        @advice[13]=l(:test1_d14_c)
      end
    end
    if ot < 4
      @advice[14]=l(:test1_d15_a)
    else
      if ot <= 7
        @advice[14]=l(:test1_d15_b)
      else
        @advice[14]=l(:test1_d15_c)
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
    strXML = "<chart palette='2' caption='"+l(:test1)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:test1_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_8)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:test1_label_9)+"' lineThickness='3' renderAs='Line' >"
    strXML = strXML +"<set value='42' /><set value='37' /><set value='40' /><set value='68' /><set value='38' /><set value='42' /><set value='68' /><set value='38' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:test1_label_10)+"' lineThickness='4' renderAs='Line' >"
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
    @chart1= renderChart("/charts/MSCombi2D.swf", "", strXML, "test3", 770, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:test1)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='100'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' >"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:test1_label_18)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_19)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_20)+"'/>"
    strXML = strXML + "<category label= '"+l(:test1_label_21)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:test1_label_22)+"' color='b23f3f'>"
    strXML = strXML +"<set value='"+@answer.answ59.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ61.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ63.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ65.to_s+"' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:test1_label_23)+"' renderAs='Area' color='759a0c'>"
    strXML = strXML +"<set value='"+@answer.answ60.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ62.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ64.to_s+"' />"
    strXML = strXML +"<set value='"+@answer.answ66.to_s+"' />"
    strXML = strXML + "</dataset> </chart>"
    @chart2= renderChart("/charts/MSCombi2D.swf", "", strXML, "test3_2", 450, 300, false, false)

    strXML=''
    strXML ="<chart palette='2' caption='"+l(:test1)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+" 'showvalues='0'  formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"
    strXML = strXML + "<set label= '"+l(:test1_label_13)+"' value='"+autoControl.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:test1_label_14)+"' value='"+visionado.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:test1_label_15)+"' value='"+autoMotivacion.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:test1_label_16)+"' value='"+ego.to_s+"'/>"
    strXML = strXML + "<set label= '"+l(:test1_label_17)+"' value='"+ot.to_s+"'/>"
    strXML = strXML + "</chart>"
    @chart3= renderChart("/charts/Column2D.swf", "", strXML, "test3_2", 450, 300, false, false)
  end
end
