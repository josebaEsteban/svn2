class Quest3Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=3
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

    t = @answer.answ1 + @answer.answ6  + @answer.answ11
    d = @answer.answ2 + @answer.answ7 + @answer.answ11
    h = @answer.answ5 + @answer.answ10 + @answer.answ15
    v = @answer.answ4 + @answer.answ9 + @answer.answ14
    f = @answer.answ3 + @answer.answ8 + @answer.answ13
    ce = (@answer.answ16 + @answer.answ19 + @answer.answ22)*3
    ae = (@answer.answ18 + @answer.answ21 + @answer.answ24)*3
    cp = (@answer.answ17 + @answer.answ20 + @answer.answ23)*3

    @advice=[]
    if t < 5
      @advice[0]=l(:test3_d1_a)
    else
      if t < 9
        @advice[0]=l(:test3_d1_b)
      else
        @advice[0]=l(:test3_d1_c)
      end
    end
    if d < 2
      @advice[1]=l(:test3_d2_a)
    else
      if d < 6
        @advice[1]=l(:test3_d2_b)
      else
        @advice[1]=l(:test3_d2_c)
      end
    end
    if h < 3
      @advice[2]=l(:test3_d3_a)
    else
      if h < 7
        @advice[2]=l(:test3_d3_b)
      else
        @advice[2]=l(:test3_d3_c)
      end
    end
    if v < 7
      @advice[3]=l(:test3_d4_a)
    else
      if v < 10
        @advice[3]=l(:test3_d4_b)
      else
        @advice[3]=l(:test3_d4_c)
      end
    end
    if f < 4
      @advice[4]=l(:test3_d5_a)
    else
      if f < 8
        @advice[4]=l(:test3_d5_b)
      else
        @advice[4]=l(:test3_d5_c)
      end
    end
    if ce < 13
      @advice[5]=l(:test3_d6_a)
    else
      if ce < 25
        @advice[5]=l(:test3_d6_b)
      else
        @advice[5]=l(:test3_d6_c)
      end
    end
    if ae < 13
      @advice[6]=l(:test3_d7_a)
    else
      if ae < 25
        @advice[6]=l(:test3_d7_b)
      else
        @advice[6]=l(:test3_d7_c)
      end
    end
    if cp < 13
      @advice[7]=l(:test3_d7_a)
    else
      if cp < 25
        @advice[7]=l(:test3_d7_b)
      else
        @advice[7]=l(:test3_d7_c)
      end
    end

    tTrans=tVal[t]
    dTrans=dVal[d]
    hTrans=hVal[h]
    vTrans=vVal[v]
    fTrans=fVal[f]
    ceTrans=ce+36
    aeTrans=ae+36
    cpTrans=cp+36

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:test3_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4'   bgcolor='ffffff' borderColor='ffffff' chartRightMargin='35'>"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:test3_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:test3_label_8)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:test3_label_9)+"' lineThickness='3' renderAs='Line' >"
    strXML = strXML +"<set value='40' /><set value='36' /><set value='40' /><set value='70' /><set value='38' /><set value='70' /><set value='38' /><set value='70' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:test3_label_10)+"' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "<set value='" + tTrans + "'/>"
    strXML = strXML + "<set value='" + dTrans + "'/>"
    strXML = strXML + "<set value='" + hTrans + "'/>"
    strXML = strXML + "<set value='" + vTrans + "'/>"
    strXML = strXML + "<set value='" + fTrans + "'/>"
    strXML = strXML + "<set value='" + ceTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + aeTrans.to_s + "'/>"
    strXML = strXML + "<set value='" + cpTrans.to_s + "'/>"
    strXML = strXML + "</dataset> </chart>"
    puts strXML
    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf", "", strXML, "test3", 770, 300, false, false)
  end
end
