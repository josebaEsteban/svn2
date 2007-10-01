class Test1Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.questionnare_id=1
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
    @answer = Answer.find(params[:id])
    @user=User.find(@answer.user_id )

    # transformadas
    tVal = %w(36 36 38 42 46 49 53 57 60 64 68 71 75)
    dVal = %w(41 45 49 52 56 60 64 67 71 75 79 79 79)
    hVal = %w(38 42 45 49 53 56 60 63 67 70 74 77 79)
    vVal = %w(36 36 36 37 41 44 48 51 55 59 62 66 69)
    fVal = %w(36 39 42 45 49 52 55 59 62 65 68 72 75)

    tension= @answer.answ1 + @answer.answ11  + @answer.answ16
    depresion= @answer.answ2 + @answer.answ7 + @answer.answ12
    hostilidad = @answer.answ5 + @answer.answ10  + @answer.answ15
    vigor = @answer.answ4 + @answer.answ9 + @answer.answ14
    fatiga = @answer.answ3 + @answer.answ8 + @answer.answ13
    ansiedadCognitiva = @answer.answ26 + @answer.answ29 + @answer.answ32 + @answer.answ35 + @answer.answ38 + @answer.answ41 + @answer.answ44 + @answer.answ47 + @answer.answ50
    autoConfianza = @answer.answ28 + @answer.answ31 + @answer.answ34 + @answer.answ37 + @answer.answ40 + @answer.answ43 + @answer.answ46 + @answer.answ49 + @answer.answ52
    ansiedadSomatica = @answer.answ27 + @answer.answ30 + @answer.answ33 + @answer.answ36 + @answer.answ39 + @answer.answ42 + @answer.answ45 + @answer.answ48 + @answer.answ51
    # item9 #dpe
    # item10 #graco
    # item11 = ((@answer.answ18 + @answer.answ19) /2) *2.5
    # item12 = ((@answer.answ20 + @answer.answ21 + @answer.answ22) /3) *2.5
    # item13 = ((@answer.answ23 + @answer.answ24 + @answer.answ25) /3) *2.5
    # item14 = ((@answer.answ57 + @answer.answ58 + @answer.answ61 + @answer.answ62 + @answer.answ65 + @answer.answ68) /6) /10
    # item15 = ((@answer.answ59 + @answer.answ60 + @answer.answ63 + @answer.answ64 + @answer.answ66 + @answer.answ67) /6) /10

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
    puts ansiedadCognitiva
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


    # vg=((item4+item5+item6+item7/4))-((item1+item2+item3)/3)
    # 
    # if vg < 0
    #   @advice[7]=l(:test1_val_4)
    # elsif vg < 1
    #   @advice[7]=l(:test1_val_3)
    # elsif vg < 3
    #   @advice[7]=l(:test1_val_2)
    # else
    #   @advice[7]=l(:test1_val_1)
    # end

    tTrans=tVal[tension]
    dTrans=dVal[depresion]
    hTrans=hVal[hostilidad]
    vTrans=vVal[vigor]
    fTrans=fVal[fatiga]
    acTrans=ansiedadCognitiva+36
    atTrans=autoConfianza+36
    asTrans=ansiedadSomatica+36

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:test1)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'   bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
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
    strXML = strXML + "<set value='" + tTrans + "'/>"
    strXML = strXML + "<set value='" + dTrans + "'/>"
    strXML = strXML + "<set value='" + hTrans + "'/>"
    strXML = strXML + "<set value='" + vTrans + "'/>"
    strXML = strXML + "<set value='" + fTrans + "'/>"
    strXML = strXML + "<set value='" + acTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + atTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + asTrans.to_s + "'/>"
    strXML = strXML + "</dataset> </chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf", "", strXML, "test3", 770, 300, false, false)
  end
end
