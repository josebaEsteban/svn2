class Quest5Controller < ApplicationController
  layout 'base'
  before_filter :require_login, :require_suscription

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
    @answer.quest_id=5
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
    if @answer.save
      # flash[:notice] = 'Answer was successfully created.'
      journal( "quest5/create/"+@answer.id.to_s, @answer.user_id)
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
    journal( "quest5/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart5
  end

  def teskalChart5
    # @answer = Answer.find(:first)
    # calculo de las dimensiones

    rendimientoGeneral = @answer.answ1 + @answer.answ2  + @answer.answ3 + @answer.answ4 + @answer.answ5
    rendimientoEmocional =  @answer.answ6 + @answer.answ7 + @answer.answ8 + @answer.answ9 + @answer.answ10
    rcog = @answer.answ11 + @answer.answ12 + @answer.answ13 + @answer.answ14 + @answer.answ15
    rcom = @answer.answ16 + @answer.answ17 + @answer.answ18 + @answer.answ19 + @answer.answ20
    cl = rendimientoGeneral + rendimientoEmocional + rcog + rcom
    ct = @answer.answ21
    x = (cl + ct) / 2
    y = (cl - ct).abs

    @advice=[]
    @icon=[]
    item=0
    if rendimientoGeneral < 14
      @advice[item]=l(:quest5_d1_a)
      @icon[item]="stop"
    else
      if rendimientoGeneral < 20
        @advice[item]=l(:quest5_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest5_d1_c)
        @icon[item]="star"
      end
    end
    item=1
    if rendimientoEmocional < 14
      @advice[item]=l(:quest5_d2_a)
      @icon[item]="stop"
    else
      if rendimientoEmocional < 20
        @advice[item]=l(:quest5_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest5_d2_c)
        @icon[item]="star"
      end
    end
    item=2
    if rcog < 14
      @advice[item]=l(:quest5_d3_a)
      @icon[item]="stop"
    else
      if rcog < 20
        @advice[item]=l(:quest5_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest5_d3_c)
        @icon[item]="star"
      end
    end
    item=3
    if rcom < 14
      @advice[item]=l(:quest5_d4_a)
      @icon[item]="stop"
    else
      if rcom < 20
        @advice[item]=l(:quest5_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest5_d4_c)
        @icon[item]="star"
      end
    end
    item=4
    case
    when x < 60
      @icon[item]="stop"
      case
      when y < 15
        @advice[item]=l(:quest5_val_g)
      when y < 30
        @advice[item]=l(:quest5_val_h)
      else
        @advice[item]=l(:quest5_val_i)
      end
    when x < 80
      @icon[item]="medium"
      case
      when y < 15
        @advice[item]=l(:quest5_val_d)
      when y < 30
        @advice[item]=l(:quest5_val_e)
      else
        @advice[item]=l(:quest5_val_f)
      end
    else
      @icon[item]="star"
      case
      when y < 15
        @advice[item]=l(:quest5_val_a)
      when y < 30
        @advice[item]=l(:quest5_val_c)
      else
        @advice[item]=l(:quest5_val_c)
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''


    #Generate the chart element
    strXML = "<chart caption='"+l(:quest5_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='25' showvalues='0'  PYAxisName='Comarcas' formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:quest5_label_1) + "' value= '" + rendimientoGeneral.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest5_label_2) + "' value= '" + rendimientoEmocional.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest5_label_3) + "' value= '" + rcog.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:quest5_label_4) + "' value= '" + rcom.to_s + "'/>"
    strXML = strXML + "</chart>"
    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf"+l(:PBarLoadingText), "", strXML, "quest5", 550, 270, false, false)
  end
end
