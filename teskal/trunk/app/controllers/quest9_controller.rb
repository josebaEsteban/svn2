class Quest9Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=9
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
    @answer = Answer.find(params[:id])
    @fecha = l_datetime(@answer.created_on)

    @user=User.find(@answer.user_id )
    teskalChart9
  end


  def teskalChart9
    @advice=[]

    peg = (@answer.answ3 + @answer.answ4 + @answer.answ5)/3.0
    if peg < 2.5
      @advice[0]=l(:quest9_d1_a)
    else
      if peg < 4
        @advice[0]=l(:quest9_d1_b)
      else
        @advice[0]=l(:quest9_d1_c)
      end
    end
    co = (@answer.answ16 + @answer.answ17 + @answer.answ19 + @answer.answ20)/4.0
    if co < 2.5
      @advice[1]=l(:quest9_d2_a)
    else
      if co < 4
        @advice[1]=l(:quest9_d2_b)
      else
        @advice[1]=l(:quest9_d2_c)
      end
    end
    ca = (@answer.answ6 + @answer.answ7 + @answer.answ11)/3.0
    if ca < 2.5
      @advice[2]=l(:quest9_d3_a)
    else
      if ca < 4
        @advice[2]=l(:quest9_d3_b)
      else
        @advice[2]=l(:quest9_d3_c)
      end
    end
    cr = (@answer.answ13 + @answer.answ14)/2.0
    if cr < 2.5
      @advice[3]=l(:quest9_d4_a)
    else
      if cr < 4
        @advice[3]=l(:quest9_d4_b)
      else
        @advice[3]=l(:quest9_d4_c)
      end
    end
    ci = (@answer.answ18 + @answer.answ15)/2.0
    if ci < 2.5
      @advice[4]=l(:quest9_d5_a)
    else
      if ci < 4
        @advice[4]=l(:quest9_d5_b)
      else
        @advice[4]=l(:quest9_d5_c)
      end
    end
    ed = (@answer.answ1 + @answer.answ11)/2.0
    if ed < 2.5
      @advice[5]=l(:quest9_d6_a)
    else
      if ed < 4
        @advice[5]=l(:quest9_d6_b)
      else
        @advice[5]=l(:quest9_d6_c)
      end
    end
    pem = (@answer.answ2 + @answer.answ18)/2.0
    if pem < 2.5
      @advice[6]=l(:quest9_d7_a)
    else
      if pem < 4
        @advice[6]=l(:quest9_d7_b)
      else
        @advice[6]=l(:quest9_d7_c)
      end
    end
    per = (@answer.answ9 + @answer.answ12)/2.0
    if per < 2.5
      @advice[7]=l(:quest9_d8_a)
    else
      if per < 4
        @advice[7]=l(:quest9_d8_b)
      else
        @advice[7]=l(:quest9_d8_c)
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''
    #Generate the chart element
    # labelDisplay='Stagger' staggerLines='2'
    strXML = "<chart palette='2' caption='"+l(:quest9_label_0)+"' subCaption='"+@user.login+"' xAxisName='"+@fecha.to_s+"'showvalues='0'  decimalSeparator=',' formatNumberScale='0' legendAllowDrag='1' yAxisMinValue='0' yAxisMaxValue='6' showShadow='1'  useRoundEdges='1' showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff' chartLeftMargin='25' chartRightMargin='35'>"
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
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_9)+"' lineThickness='3' renderAs='Line' >"
    strXML = strXML +"<set value='4' /><set value='3' /><set value='3' /><set value='3' /><set value='2' /><set value='4' /><set value='5' /><set value='3' />"
    strXML = strXML +"</dataset>"
    strXML = strXML +"<dataset SeriesName='"+l(:quest3_label_10)+"' lineThickness='4' renderAs='Area' >"
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
    @chart1= renderChart("/charts/MSCombi2D.swf", "", strXML, "quest3", 750, 300, false, false)
  end
end
