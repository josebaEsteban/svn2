#tolerancia al stress

class Quest2Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end
  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=2
    @answer.user_id=session[:user_id]
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      redirect_to :action => 'show', :id => @answer.id

      # format.html { redirect_to answer_url(@answer) }
      # format.xml  { head :created, :location => answer_url(@answer) }
    else
      flash[:notice] = ' nil'
      redirect_to :action => 'new'
      #         format.html { render :action => "new" }
      # format.xml  { render :xml => @answer.errors.to_xml }
    end
  end

  def show

    #Database Objects - Initialization
    @answer = Answer.find(params[:id])
    # @answer = Answer.find(session[:use)
    @fecha = l_datetime(@answer.created_on)

    @user=User.find(@answer.user_id )
    teskalChart2
  end

  def teskalChart2
    # @answer = Answer.find_first
    # calculo de las dimensiones
    descansoInterrumpido = (@answer.answ2 + @answer.answ9  + @answer.answ17 + @answer.answ23) /4.0
    cansancioEmocional = (@answer.answ5 + @answer.answ14 + @answer.answ19 + @answer.answ27) /4.0
    vulnerabilidadLesiones = (@answer.answ1 + @answer.answ8  + @answer.answ15 + @answer.answ24) /4.0
    estadoForma = (@answer.answ4 + @answer.answ12 + @answer.answ20 + @answer.answ26) /4.0
    logroPersonal = (@answer.answ6 + @answer.answ11 + @answer.answ21 + @answer.answ28) /4.0
    autoEficacia = (@answer.answ3 + @answer.answ10 + @answer.answ16 + @answer.answ22) /4.0
    autoRegulacion = (@answer.answ7 + @answer.answ13 + @answer.answ18 + @answer.answ25) /4.0

    @advice=[]
    if descansoInterrumpido < 2
      @advice[0]=l(:quest2_d1_a)
    else
      if descansoInterrumpido < 4
        @advice[0]=l(:quest2_d1_b)
      else
        @advice[0]=l(:quest2_d1_c)
      end
    end
    if cansancioEmocional < 2
      @advice[1]=l(:quest2_d2_a)
    else
      if cansancioEmocional < 4
        @advice[1]=l(:quest2_d2_b)
      else
        @advice[1]=l(:quest2_d2_c)
      end
    end
    if vulnerabilidadLesiones < 2
      @advice[2]=l(:quest2_d3_a)
    else
      if vulnerabilidadLesiones < 4
        @advice[2]=l(:quest2_d3_b)
      else
        @advice[2]=l(:quest2_d3_c)
      end
    end
    if estadoForma < 2
      @advice[3]=l(:quest2_d4_a)
    else
      if estadoForma < 4
        @advice[3]=l(:quest2_d4_b)
      else
        @advice[3]=l(:quest2_d4_c)
      end
    end
    if logroPersonal < 2
      @advice[4]=l(:quest2_d5_a)
    else
      if logroPersonal < 4
        @advice[4]=l(:quest2_d5_b)
      else
        @advice[4]=l(:quest2_d5_c)
      end
    end
    if autoEficacia < 2
      @advice[5]=l(:quest2_d6_a)
    else
      if autoEficacia < 4
        @advice[5]=l(:quest2_d6_b)
      else
        @advice[5]=l(:quest2_d6_c)
      end
    end
    if autoRegulacion < 2
      @advice[6]=l(:quest2_d7_a)
    else
      if autoRegulacion < 4
        @advice[6]=l(:quest2_d7_b)
      else
        @advice[6]=l(:quest2_d7_c)
      end
    end
    vg=((estadoForma+logroPersonal+autoEficacia+autoRegulacion/4.0))-((descansoInterrumpido+cansancioEmocional+vulnerabilidadLesiones)/3.0)

    if vg < 0
      @advice[7]=l(:quest2_val_4)
    elsif vg < 1
      @advice[7]=l(:quest2_val_3)
    elsif vg < 3
      @advice[7]=l(:quest2_val_2)
    else
      @advice[7]=l(:quest2_val_1)
    end
    #strXML will be used to store the entire XML document generated
    strXML=''

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest2_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMinValue='-6' yAxisMaxValue='6' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:quest2_label_1) + "' value='-" + acorta(descansoInterrumpido)  + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_2) + "' value='-" + acorta(vulnerabilidadLesiones)  + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_3) + "' value='-" + acorta(vulnerabilidadLesiones)+ "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_4) + "' value='" + acorta(estadoForma) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_5) + "' value='" + acorta(logroPersonal) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_6) + "' value='" + acorta(autoEficacia) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_7) + "' value='" + acorta(autoRegulacion) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "quest2", 550, 300, false, false)
  end
end
