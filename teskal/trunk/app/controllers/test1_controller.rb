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
    # @answer = Answer.find_first
    # calculo de las dimensiones

    # Tension
    # 1,11,6
    # Depresion
    # 2-7-12
    # Hostilidad
    # 5-10-15
    # vigor
    # 4-9-14
    # fatiga
    # 3-8-13
    # ansiedad cognitiva
    # 30,33,36,39,42,45,48,51,54
    # autoconfianza
    # 32,35,37,41,44,47,50,53,56
    # ansiedad somatica
    # 31,34,37,40,43,45,49,52,55

    item1 = @answer.answ1 + @answer.answ11  + @answer.answ16
    item2 = @answer.answ2 + @answer.answ7 + @answer.answ12
    item3 = @answer.answ5 + @answer.answ10  + @answer.answ15
    item4 = @answer.answ4 + @answer.answ9 + @answer.answ14
    item5 = @answer.answ3 + @answer.answ8 + @answer.answ13
    item6 = @answer.answ30 + @answer.answ33 + @answer.answ36 + @answer.answ39 + @answer.answ42 + @answer.answ45 + @answer.answ48 + @answer.answ51 + @answer.answ54
    item7 = @answer.answ32 + @answer.answ35 + @answer.answ38 + @answer.answ41 + @answer.answ44 + @answer.answ47 + @answer.answ50 + @answer.answ53 + @answer.answ56
    item8 = @answer.answ31 + @answer.answ34 + @answer.answ37 + @answer.answ40 + @answer.answ43 + @answer.answ46 + @answer.answ49 + @answer.answ52 + @answer.answ55
    item9 #dpe
    item10 #graco
    item11 = ((@answer.answ18 + @answer.answ19) /2) *2.5
    item12 = ((@answer.answ20 + @answer.answ21 + @answer.answ22) /3) *2.5
    item13 = ((@answer.answ23 + @answer.answ24 + @answer.answ25) /3) *2.5
    item14 = ((@answer.answ57 + @answer.answ58 + @answer.answ61 + @answer.answ62 + @answer.answ65 + @answer.answ68) /6) /10
    item15 = ((@answer.answ59 + @answer.answ60 + @answer.answ63 + @answer.answ64 + @answer.answ66 + @answer.answ67) /6) /10

    @advice=[]
    if item1 < 5
      @advice[0]=l(:test1_d1_a)
    else
      if item1 < 9
        @advice[0]=l(:test1_d1_b)
      else
        @advice[0]=l(:test1_d1_c)
      end
    end
    if item2 < 4
      @advice[1]=l(:test1_d2_a)
    else
      if item2 < 9
        @advice[1]=l(:test1_d2_b)
      else
        @advice[1]=l(:test1_d2_c)
      end
    end
    if item3 < 3
      @advice[2]=l(:test1_d3_a)
    else
      if item3 < 7
        @advice[2]=l(:test1_d3_b)
      else
        @advice[2]=l(:test1_d3_c)
      end
    end
    if item4 < 7
      @advice[3]=l(:test1_d4_a)
    else
      if item4 < 10
        @advice[3]=l(:test1_d4_b)
      else
        @advice[3]=l(:test1_d4_c)
      end
    end
    if item5 < 4
      @advice[4]=l(:test1_d5_a)
    else
      if item5 < 8
        @advice[4]=l(:test1_d5_b)
      else
        @advice[4]=l(:test1_d5_c)
      end
    end
    if item6 < 13
      @advice[5]=l(:test1_d6_a)
    else
      if item6 < 25
        @advice[5]=l(:test1_d6_b)
      else
        @advice[5]=l(:test1_d6_c)
      end
    end
    if item7 < 13
      @advice[6]=l(:test1_d7_a)
    else
      if item7 < 25
        @advice[6]=l(:test1_d7_b)
      else
        @advice[6]=l(:test1_d7_c)
      end
    end
    if item8 < 13
      @advice[7]=l(:test1_d7_a)
    else
      if item8 < 25
        @advice[7]=l(:test1_d7_b)
      else
        @advice[7]=l(:test1_d7_c)
      end
    end


    vg=((item4+item5+item6+item7/4))-((item1+item2+item3)/3)

    if vg < 0
      @advice[7]=l(:test1_val_4)
    elsif vg < 1
      @advice[7]=l(:test1_val_3)
    elsif vg < 3
      @advice[7]=l(:test1_val_2)
    else
      @advice[7]=l(:test1_val_1)
    end
    #strXML will be used to store the entire XML document generated
    strXML=''


    #Generate the chart element
    strXML = "<chart caption='"+l(:test1_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' showvalues='0'  PYAxisName='' SYAxisName='' decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='36' yAxisMaxValue='72' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' labelDisplay='Stagger' staggerLines='2'>"

    strXML = strXML + "<set label='" + l(:test1_label_1) + "' value='-" + item1.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_2) + "' value='-" + item2.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_3) + "' value='-" + item3.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_4) + "' value='" + item4.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_5) + "' value='" + item5.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_6) + "' value='" + item6.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test1_label_7) + "' value='" + item7.to_s + "'/>"
    strXML = strXML + "<dataset SeriesName='Optimo' lineThickness='3' renderAs='Line' >
    <set value='42' />
    <set value='37' />
    <set value='40' />
    <set value='68' />
    <set value='38' />
    <set value='42' />
    <set value='68' />
    <set value='38' />
    </dataset><dataset SeriesName='Actual' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "test1", 550, 300, false, false)
  end
end
