class Quest5Controller < ApplicationController
  layout 'base'
  before_filter :require_login

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.quest_id=5
    @answer.user_id=session[:user_id]
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
    teskalChart5
  end
  
  def teskalChart5
    # @answer = Answer.find_first
    # calculo de las dimensiones

    rg = @answer.answ1 + @answer.answ2  + @answer.answ3 + @answer.answ4 + @answer.answ5
    re =  @answer.answ6 + @answer.answ7 + @answer.answ8 + @answer.answ9 + @answer.answ10
    rcog = @answer.answ11 + @answer.answ12 + @answer.answ13 + @answer.answ14 + @answer.answ15
    rcom = @answer.answ16 + @answer.answ17 + @answer.answ18 + @answer.answ19 + @answer.answ20
    cl = (rg + re + rcog + rcom)
    ct = @answer.answ21
    x = (cl + ct) / 2
    y = (cl - ct).abs
    
    @advice=[]
    if rg < 14
      @advice[0]=l(:test5_d1_a)
    else
      if rg < 20
        @advice[0]=l(:test5_d1_b)
      else
        @advice[0]=l(:test5_d1_c)
      end
    end
    if re < 14
      @advice[1]=l(:test5_d2_a)
    else
      if re < 20
        @advice[1]=l(:test5_d2_b)
      else
        @advice[1]=l(:test5_d2_c)
      end
    end
    if rcog < 14
      @advice[2]=l(:test5_d3_a)
    else
      if rcog < 20
        @advice[2]=l(:test5_d3_a)
      else
        @advice[2]=l(:test5_d3_a)
      end
    end
    if rcom < 14
      @advice[3]=l(:test5_d4_a)
    else
      if rcom < 20
        @advice[3]=l(:test5_d4_b)
      else
        @advice[3]=l(:test5_d4_c)
      end
    end
    case
    when x < 60
      case
      when y < 15
        @advice[4]=l(:test5_val_g)
      when y < 30
        @advice[4]=l(:test5_val_h)
      else
        @advice[4]=l(:test5_val_i)
      end
    when x < 80
      case
      when y < 15
        @advice[4]=l(:test5_val_d)
      when y < 30
        @advice[4]=l(:test5_val_e)
      else
        @advice[4]=l(:test5_val_f)
      end
    else
      case
      when y < 15
        @advice[4]=l(:test5_val_a)
      when y < 30
        @advice[4]=l(:test5_val_c)
      else
        @advice[4]=l(:test5_val_c)
      end
    end

    #strXML will be used to store the entire XML document generated
    strXML=''


    #Generate the chart element
    strXML = "<chart caption='"+l(:test5_label_0)+"' subCaption='"+@user.login+"' yAxisName='"+@fecha.to_s+"' palette='2' yAxisMaxValue='30' showvalues='0'  PYAxisName='Comarcas' formatNumberScale='0' legendAllowDrag='1' showShadow='1'  useRoundEdges='1' yAxisMaxValue='10'  showAlternateHGridColor='1' alternateHGridColor='f8f6f4' bgcolor='ffffff' borderColor='ffffff'>"

    strXML = strXML + "<set label='" + l(:test5_label_1) + "' value= '" + rg.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test5_label_2) + "' value= '" + re.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test5_label_3) + "' value= '" + rcog.to_s + "'/>"
    strXML = strXML + "<set label='" + l(:test5_label_4) + "' value= '" + rcom.to_s + "'/>"
    strXML = strXML + "</chart>"
    #Create the chart - Pie 3D Chart with data from strXML
    @chart1= renderChart("/charts/Bar2D.swf", "", strXML, "test5", 550, 270, false, false)
  end
end
