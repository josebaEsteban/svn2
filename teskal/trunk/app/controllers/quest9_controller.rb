class Quest9Controller < ApplicationController
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
    @answer.quest_id=9
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
      journal( "quest9/create/"+@answer.id.to_s, @answer.user_id)
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
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest9/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart9
  end


  def teskalChart9
    scale=10/5
    @advice=[]
    @icon=[]
    valor_bajo = 2.5 * scale
    valor_medio = 4 * scale

    peg = ((@answer.answ3 + @answer.answ5) * scale) /2.0
    item=0
    if peg < valor_bajo
      @advice[item]=l(:quest9_d1_a)
      @icon[item]="star"
    else
      if peg < valor_medio
        @advice[item]=l(:quest9_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d1_c)
        @icon[item]="stop"
      end
    end
    maestria_grupal = ((@answer.answ4 + @answer.answ21)/2.0) * scale
    item=1
    if maestria_grupal < valor_bajo
      @advice[item]=l(:quest9_d2_a)
      @icon[item]="stop"
    else
      if maestria_grupal < valor_medio
        @advice[item]=l(:quest9_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d2_c)
        @icon[item]="star"
      end
    end
    co = ((@answer.answ16 + @answer.answ17 + @answer.answ19 + @answer.answ20)/4.0) * scale
    item=2
    if co < valor_bajo
      @advice[item]=l(:quest9_d3_a)
      @icon[item]="stop"
    else
      if co < valor_medio
        @advice[item]=l(:quest9_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d3_c)
        @icon[item]="star"
      end
    end
    ca = ((@answer.answ6 + @answer.answ7 + @answer.answ11)/3.0) * scale
    item=3
    if ca < valor_bajo
      @advice[item]=l(:quest9_d4_a)
      @icon[item]="stop"
    else
      if ca < valor_medio
        @advice[item]=l(:quest9_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d4_c)
        @icon[item]="star"
      end
    end
    cr = ((@answer.answ13 + @answer.answ14)/2.0) * scale
    item=4
    if cr < valor_bajo
      @advice[item]=l(:quest9_d5_a)
      @icon[item]="star"
    else
      if cr < valor_medio
        @advice[item]=l(:quest9_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d5_c)
        @icon[item]="stop"
      end
    end
    ci = ((@answer.answ8 + @answer.answ15)/2.0) * scale
    item=5
    if ci < valor_bajo
      @advice[item]=l(:quest9_d6_a)
      @icon[item]="stop"
    else
      if ci < valor_medio
        @advice[item]=l(:quest9_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d6_c)
        @icon[item]="star"
      end
    end
    ed = ((@answer.answ1 + @answer.answ10)/2.0) * scale
    item=6
    if ed < valor_bajo
      @advice[item]=l(:quest9_d7_a)
      @icon[item]="stop"
    else
      if ed < valor_medio
        @advice[item]=l(:quest9_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d7_c)
        @icon[item]="star"
      end
    end
    pem = ((@answer.answ2 + @answer.answ18)/2.0) * scale
    item=7
    if pem < valor_bajo
      @advice[item]=l(:quest9_d8_a)
      @icon[item]="stop"
    else
      if pem < valor_medio
        @advice[item]=l(:quest9_d8_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d8_c)
        @icon[item]="star"
      end
    end
    per = ((@answer.answ9 + @answer.answ12)/2.0) * scale
    item=8
    if per < valor_bajo
      @advice[item]=l(:quest9_d9_a)
      @icon[item]="star"
    else
      if per < valor_medio
        @advice[item]=l(:quest9_d9_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d9_c)
        @icon[item]="stop"
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''
    # before scaling to base 10
    # yAxisMaxValue='5'

    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest9_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='10' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartLeftMargin='25' chartRightMargin='35'>"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:quest9_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_8)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_9)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Area' >"
    strXML = strXML +"<set value='"+(1*scale).to_s+"'/><set value='"+(5*scale).to_s+"' /><set value='"+(5*scale).to_s+"'/><set value='"+(5*scale).to_s+"'/><set value='"+(1*scale).to_s+"'/><set value='"+(5*scale).to_s+"'/><set value='"+(5*scale).to_s+"'/><set value='"+(5*scale).to_s+"'/><set value='"+(3*scale).to_s+"'/>"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_10)+"' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "<set value='" + acorta(peg) + "'/>"
    strXML = strXML + "<set value='" + acorta(maestria_grupal) + "'/>"
    strXML = strXML + "<set value='" + acorta(co) + "'/>"
    strXML = strXML + "<set value='" + acorta(ca) + "'/>"
    strXML = strXML + "<set value='" + acorta(cr) + "'/>"
    strXML = strXML + "<set value='" + acorta(ci) + "'/>"
    strXML = strXML + "<set value='" + acorta(ed)+ "'/>"
    strXML = strXML + "<set value='" + acorta(pem) + "'/>"
    strXML = strXML + "<set value='" + acorta(per) + "'/>"
    strXML = strXML + "</dataset> </chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 830, 300, false, false)
  end
end
