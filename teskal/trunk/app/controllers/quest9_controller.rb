class Quest9Controller < ApplicationController
  layout 'base'
  before_filter :require_login, :require_suscription

  def new
    user=User.find(session[:user_id])
    user.start = Time.now
    user.save
    if !params[:id].nil?
      user.filled_for = params[:id]
    else
      user.filled_for = session[:user_id]
    end
  end

  def create
    @answer = Answer.new(params[:answer])
    user=User.find(session[:user_id])
    @answer.quest_id=9
    if user.filled_for == session[:user_id]
      @answer.user_id=session[:user_id]
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
    @fecha = l_datetime(@answer.created_on)
    @user=User.find(@answer.user_id )
    @browse_score = answer_show(@answer.user_id, @answer.browse, @user.managed_by)
    journal( "quest9/show/"+@answer.id.to_s, @answer.user_id)
    TzTime.zone=@user.timezone
    @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    teskalChart9
  end


  def teskalChart9
    @advice=[]
    @icon=[]

    peg = (@answer.answ3 + @answer.answ4 + @answer.answ5)/3.0
    item=0
    if peg < 2.5
      @advice[item]=l(:quest9_d1_a)
      @icon[item]="stop"
    else
      if peg < 4
        @advice[item]=l(:quest9_d1_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d1_c)
        @icon[item]="star"
      end
    end
    co = (@answer.answ16 + @answer.answ17 + @answer.answ19 + @answer.answ20)/4.0
    item=1
    if co < 2.5
      @advice[item]=l(:quest9_d2_a)
      @icon[item]="stop"
    else
      if co < 4
        @advice[item]=l(:quest9_d2_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d2_c)
        @icon[item]="star"
      end
    end
    ca = (@answer.answ6 + @answer.answ7 + @answer.answ11)/3.0
    item=2
    if ca < 2.5
      @advice[item]=l(:quest9_d3_a)
      @icon[item]="stop"
    else
      if ca < 4
        @advice[item]=l(:quest9_d3_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d3_c)
        @icon[item]="star"
      end
    end
    cr = (@answer.answ13 + @answer.answ14)/2.0
    item=3
    if cr < 2.5
      @advice[item]=l(:quest9_d4_a)
      @icon[item]="stop"
    else
      if cr < 4
        @advice[item]=l(:quest9_d4_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d4_c)
        @icon[item]="star"
      end
    end
    ci = (@answer.answ8 + @answer.answ15)/2.0
    item=4
    if ci < 2.5
      @advice[item]=l(:quest9_d5_a)
      @icon[item]="stop"
    else
      if ci < 4
        @advice[item]=l(:quest9_d5_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d5_c)
        @icon[item]="star"
      end
    end
    ed = (@answer.answ1 + @answer.answ10)/2.0
    item=5
    if ed < 2.5
      @advice[item]=l(:quest9_d6_a)
      @icon[item]="stop"
    else
      if ed < 4
        @advice[item]=l(:quest9_d6_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d6_c)
        @icon[item]="star"
      end
    end
    pem = (@answer.answ2 + @answer.answ18)/2.0
    item=6
    if pem < 2.5
      @advice[item]=l(:quest9_d7_a)
      @icon[item]="stop"
    else
      if pem < 4
        @advice[item]=l(:quest9_d7_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d7_c)
        @icon[item]="star"
      end
    end
    per = (@answer.answ9 + @answer.answ12)/2.0
    item=7
    if per < 2.5
      @advice[item]=l(:quest9_d8_a)
      @icon[item]="stop"
    else
      if per < 4
        @advice[item]=l(:quest9_d8_b)
        @icon[item]="medium"
      else
        @advice[item]=l(:quest9_d8_c)
        @icon[item]="star"
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest9_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='5' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartLeftMargin='25' chartRightMargin='35'>"
    strXML = strXML +"<categories>"
    strXML = strXML + "<category label= '"+l(:quest9_label_1)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_2)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_3)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_4)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_5)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_6)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_7)+"'/>"
    strXML = strXML + "<category label= '"+l(:quest9_label_8)+"'/>"
    strXML = strXML +"</categories>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Area' >"
    strXML = strXML +"<set value='2.5' /><set value='5' /><set value='5' /><set value='1' /><set value='5' /><set value='5' /><set value='5' /><set value='3' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_10)+"' lineThickness='4' renderAs='Line' >"
    strXML = strXML + "<set value='" + acorta(peg) + "'/>"
    strXML = strXML + "<set value='" + acorta(co) + "'/>"
    strXML = strXML + "<set value='" + acorta(ca) + "'/>"
    strXML = strXML + "<set value='" + acorta(cr) + "'/>"
    strXML = strXML + "<set value='" + acorta(ci) + "'/>"
    strXML = strXML + "<set value='" + acorta(ed)+ "'/>"
    strXML = strXML + "<set value='" + acorta(pem) + "'/>"
    strXML = strXML + "<set value='" + acorta(per) + "'/>"
    strXML = strXML + "</dataset> </chart>"

    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/MSCombi2D.swf"+l(:PBarLoadingText), "", strXML, "quest3", 750, 300, false, false)
  end
end
