#tolerancia al stress

class Test2Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end
  def create
    @answer = Answer.new(params[:answer])
    @answer.questionnare_id=2
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

    #Database Objects - Initialization
    @answer = Answer.find(params[:id])
    @fecha = l_datetime(@answer.created_on)

    @user=User.find(@answer.user_id )
    teskalChart2
    end
    
    def teskalChart2
    # @answer = Answer.find_first
    # calculo de las dimensiones

    # Descanso Interrumpido
    # 2,9,17,23
    # Cansancio Emocional
    # 5,14,19,27
    # Vulnerabilidad a Las Lesiones
    # 1,8,15,24
    # Estado De Forma
    # 4,12,20,26
    # Logro Personal
    # 6,11,21,28
    # Autoeficacia
    # 3,10,16,22
    # Autorregulación
    # 7,13,18,25
    item1 = (@answer.answ2 + @answer.answ9  + @answer.answ17 + @answer.answ23) /4
    item2 = (@answer.answ5 + @answer.answ14 + @answer.answ19 + @answer.answ27) /4
    item3 = (@answer.answ1 + @answer.answ8  + @answer.answ15 + @answer.answ24) /4
    item4 = (@answer.answ4 + @answer.answ12 + @answer.answ20 + @answer.answ26) /4
    item5 = (@answer.answ6 + @answer.answ11 + @answer.answ21 + @answer.answ28) /4
    item6 = (@answer.answ3 + @answer.answ10 + @answer.answ16 + @answer.answ22) /4
    item7 = (@answer.answ7 + @answer.answ13 + @answer.answ18 + @answer.answ25) /4
    @advice=[]
    if item1 < 2
      @advice[0]=l(:test2_d1_a)
    else
      if item1 < 4
        @advice[0]=l(:test2_d1_b)
      else
        @advice[0]=l(:test2_d1_c)
      end
    end
    if item2 < 2
      @advice[1]=l(:test2_d2_a)
    else
      if item2 < 4
        @advice[1]=l(:test2_d2_b)
      else
        @advice[1]=l(:test2_d2_c)
      end
    end
    if item3 < 2
      @advice[2]=l(:test2_d3_a)
    else
      if item3 < 4
        @advice[2]=l(:test2_d3_b)
      else
        @advice[2]=l(:test2_d3_c)
      end
    end
    if item4 < 2
      @advice[3]=l(:test2_d4_a)
    else
      if item4 < 4
        @advice[3]=l(:test2_d4_b)
      else
        @advice[3]=l(:test2_d4_c)
      end
    end
    if item5 < 2
      @advice[4]=l(:test2_d5_a)
    else
      if item5 < 4
        @advice[4]=l(:test2_d5_b)
      else
        @advice[4]=l(:test2_d5_c)
      end
    end
    if item6 < 2
      @advice[5]=l(:test2_d6_a)
    else
      if item6 < 4
        @advice[5]=l(:test2_d6_b)
      else
        @advice[5]=l(:test2_d6_c)
      end
    end
    if item7 < 2
      @advice[6]=l(:test2_d7_a)
    else
      if item7 < 4
        @advice[6]=l(:test2_d7_b)
      else
        @advice[6]=l(:test2_d7_c)
      end
    end
    vg=((item4+item5+item6+item7/4))-((item1+item2+item3)/3)

    if vg < 0
      @advice[7]=l(:test2_val_4)
    elsif vg < 1
      @advice[7]=l(:test2_val_3)
    elsif vg < 3
      @advice[7]=l(:test2_val_2)
    else
      @advice[7]=l(:test2_val_1)
    end
    #strXML will be used to store the entire XML document generated
    strXML=''


    #Generate the chart element
    strXML = "<chart caption='"+l(:test2_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMinValue='-6' yAxisMaxValue='6' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:test2_label_1) + "' value='-" + item1.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_2) + "' value='-" + item2.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_3) + "' value='-" + item3.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_4) + "' value='" + item4.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_5) + "' value='" + item5.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_6) + "' value='" + item6.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test2_label_7) + "' value='" + item7.to_s + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "test2", 550, 300, false, false)
  end
end
