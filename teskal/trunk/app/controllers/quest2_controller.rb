#tolerancia al stress

class Quest2Controller < ApplicationController
  layout 'base'
  before_filter :require_login

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
    @answer.quest_id=2
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
      if user.show?
        @answer.browse = true
      end
    else
      @answer.user_id = user.filled_for
    end
    @answer.filled_by = session[:user_id]
    @answer.ip = request.remote_ip
    @answer.time_to_fill =  Time.now - user.start
    @answer.browse=1
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest2/create/"+@answer.id.to_s, @answer.user_id)
      pendings = Pending.find_by_sql("select id from pendings where pendings.user_id=#{@answer.user_id} and pendings.quest_id=#{@answer.quest_id} order by pendings.created_on ASC")
      if pendings.length >0
        Pending.delete(pendings[0])
      end
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
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal("quest2/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskal_chart2
  end

  def teskal_chart2
    # @answer = Answer.find(:first)
    # calculo de las dimensiones
    descansoInterrumpido = (@answer.answ2 + @answer.answ9  + @answer.answ17 + @answer.answ23) /4.0
    cansancioEmocional = (@answer.answ5 + @answer.answ14 + @answer.answ19 + @answer.answ27) /4.0
    vulnerabilidadLesiones = (@answer.answ1 + @answer.answ8  + @answer.answ15 + @answer.answ24) /4.0
    estadoForma = (@answer.answ4 + @answer.answ12 + @answer.answ20 + @answer.answ26) /4.0
    logroPersonal = (@answer.answ6 + @answer.answ11 + @answer.answ21 + @answer.answ28) /4.0
    autoEficacia = (@answer.answ3 + @answer.answ10 + @answer.answ16 + @answer.answ22) /4.0
    autoRegulacion = (@answer.answ7 + @answer.answ13 + @answer.answ18 + @answer.answ25) /4.0

    @advice=[]
    @icon=[]
    item=0
    if descansoInterrumpido < 2
      @advice[item]=l(:quest2_d1_a)
      @icon[item]="star"
    else
      if descansoInterrumpido < 4
        @advice[item]=l(:quest2_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d1_c)
        @icon[item]="stop"
      end
    end
    item=1
    if cansancioEmocional < 2
      @advice[item]=l(:quest2_d2_a)
      @icon[item]="star"
    else
      if cansancioEmocional < 4
        @advice[item]=l(:quest2_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d2_c)
        @icon[item]="stop"
      end
    end
    item=2
    if vulnerabilidadLesiones < 2
      @advice[item]=l(:quest2_d3_a)
      @icon[item]="star"
    else
      if vulnerabilidadLesiones < 4
        @advice[item]=l(:quest2_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d3_c)
        @icon[item]="stop"
      end
    end
    item=3
    if estadoForma < 2
      @advice[item]=l(:quest2_d4_a)
      @icon[item]="stop"
    else
      if estadoForma < 4
        @advice[item]=l(:quest2_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d4_c)
        @icon[item]="star"
      end
    end
    item=4
    if logroPersonal < 2
      @advice[item]=l(:quest2_d5_a)
      @icon[item]="stop"
    else
      if logroPersonal < 4
        @advice[item]=l(:quest2_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d5_c)
        @icon[item]="star"
      end
    end
    item=5
    if autoEficacia < 2
      @advice[item]=l(:quest2_d6_a)
      @icon[item]="stop"
    else
      if autoEficacia < 4
        @advice[item]=l(:quest2_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d6_c)
        @icon[item]="star"
      end
    end
    item=6
    if autoRegulacion < 2
      @advice[item]=l(:quest2_d7_a)
      @icon[item]="stop"
    else
      if autoRegulacion < 4
        @advice[item]=l(:quest2_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest2_d7_c)
        @icon[item]="star"
      end
    end
    vg=((estadoForma+logroPersonal+autoEficacia+autoRegulacion/4.0))-((descansoInterrumpido+cansancioEmocional+vulnerabilidadLesiones)/3.0)
    item=7
    if vg < 0
      @advice[item]=l(:quest2_val_4)
    elsif vg < 1
      @advice[item]=l(:quest2_val_3)
    elsif vg < 3
      @advice[item]=l(:quest2_val_2)
    else
      @advice[item]=l(:quest2_val_1)
    end
    #strXML will be used to store the entire XML document generated
    strXML=''

    #Generate the chart element
    strXML = "<chart caption='"+l(:quest2_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMinValue='-6' yAxisMaxValue='6' showShadow='1' use3DLighting='1' legendAllowDrag='1' useRoundEdges='1' noValue='0' showValues='0' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:quest2_label_1) + "' value='-" + acorta(descansoInterrumpido)  + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_2) + "' value='-" + acorta(cansancioEmocional)  + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_3) + "' value='-" + acorta(vulnerabilidadLesiones)+ "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_4) + "' value='" + acorta(estadoForma) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_5) + "' value='" + acorta(logroPersonal) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_6) + "' value='" + acorta(autoEficacia) + "'/>"
    strXML = strXML + "<set label='" + l(:quest2_label_7) + "' value='" + acorta(autoRegulacion) + "'/>"
    strXML = strXML + "</chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest2", 550, 300, false, false)
  end
end
