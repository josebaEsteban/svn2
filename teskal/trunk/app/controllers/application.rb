# Copyright (C) 2007 Teskal


class ApplicationController < ActionController::Base
  before_filter :check_if_login_required, :set_localization
  filter_parameter_logging :password
  # around_filter :set_timezone

  def logged_in_user=(user)
    @logged_in_user = user
    session[:user_id] = (user ? user.id : nil)
  end

  def logged_in_user
    if session[:user_id]
      @logged_in_user ||= User.find(session[:user_id])
    else
      nil
    end
  end

  # Returns the role that the logged in user has on the current project
  # or nil if current user is not a member of the project
  def logged_in_user_membership
    @user_membership ||= logged_in_user.role_for_project(@project)
  end

  # check if login is globally required to access the application
  def check_if_login_required
    # no check needed if user is already logged in
    return true if logged_in_user
    # auto-login feature
    autologin_key = cookies[:autologin]
    if autologin_key && Setting.autologin?
      self.logged_in_user = User.find_by_autologin_key(autologin_key)
    end
    require_login if Setting.login_required?
  end

  def set_localization
    lang = begin
      if self.logged_in_user and self.logged_in_user.language and !self.logged_in_user.language.empty? and GLoc.valid_languages.include? self.logged_in_user.language.to_sym
        self.logged_in_user.language
      elsif request.env['HTTP_ACCEPT_LANGUAGE']
        accept_lang = parse_qvalues(request.env['HTTP_ACCEPT_LANGUAGE']).first.split('-').first
        if accept_lang and !accept_lang.empty? and GLoc.valid_languages.include? accept_lang.to_sym
          accept_lang
        end
      end
    rescue
      nil
    end || Setting.default_language
    set_language_if_valid(lang)
  end

  def require_login
    unless self.logged_in_user
      store_location
      redirect_to :controller => "account", :action => "login"
      return false
    end
    true
  end

  def require_admin
    return unless require_login
    unless self.logged_in_user.admin?
      render_403
      return false
    end
    true
  end

  def require_coach
    return unless require_login
    unless self.logged_in_user.show?
      render_403
      return false
    end
    true
  end

  def answer_show?(user, browse, managed_by)

    answer_show = true
    if !@logged_in_user.admin?
      if user == session[:user_id]
        if browse == false
          answer_show = false
        else
          answer_show = true
        end
      else
        if @logged_in_user.id != managed_by
          answer_show = false
        else
          answer_show = true
        end
      end
    end
    return answer_show
  end

  # authorizes only to suscribed customers
  def require_suscription
    if @logged_in_user.suscription?

    else
      flash[:notice] = l(:notice_not_authorized)
      redirect_to :controller => 'my', :action => 'page'
    end
  end

  # authorizes the user for the requested action.
  def authorize(ctrl = params[:controller], action = params[:action])
    unless @project.active?
      @project = nil
      render_404
      return false
    end
    # check if action is allowed on public projects
    if @project.is_public? and Permission.allowed_to_public "%s/%s" % [ ctrl, action ]
      return true
    end
    # if action is not public, force login
    return unless require_login
    # admin is always authorized
    return true if self.logged_in_user.admin?
    # if not admin, check membership permission
    if logged_in_user_membership and Permission.allowed_to_role( "%s/%s" % [ ctrl, action ], logged_in_user_membership )
      return true
    end
    render_403
    false
  end

  # make sure that the user is a member of the project (or admin) if project is private
  # used as a before_filter for actions that do not require any particular permission on the project
  def check_project_privacy
    unless @project.active?
      @project = nil
      render_404
      return false
    end
    return true if @project.is_public?
    return false unless logged_in_user
    return true if logged_in_user.admin? || logged_in_user_membership
    render_403
    false
  end

  # store current uri in session.
  # return to this location by calling redirect_back_or_default
  def store_location
    session[:return_to_params] = params
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if session[:return_to_params].nil?
      redirect_to default
    else
      redirect_to session[:return_to_params]
      session[:return_to_params] = nil
    end
  end

  def render_403
    @html_title = "403"
    @project = nil
    render :template => "common/403", :layout => true, :status => 403
    return false
  end

  def render_404
    @html_title = "404"
    render :template => "common/404", :layout => true, :status => 404
    return false
  end

  # qvalues http header parser
  # code taken from webrick
  def parse_qvalues(value)
    tmp = []
    if value
      parts = value.split(/,\s*/)
      parts.each {|part|
        if m = %r{^([^\s,]+?)(?:;\s*q=(\d+(?:\.\d+)?))?$}.match(part)
          val = m[1]
          q = (m[2] or 1).to_f
          tmp.push([val, q])
        end
      }
      tmp = tmp.sort_by{|val, q| -q}
      tmp.collect!{|val, q| val}
    end
    return tmp
  end

  def renderChart(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS)
    renderChartText= "<!-- START Script Block for Chart " + chartId + " -->" + " \n "
    renderChartText= renderChartText + " \t <div id='"+chartId+"Div' align='center'>" + " \n "
    #The above text "Chart" is shown to users before the chart has started loading 	(if there is a lag in relaying SWF from server). This text is also shown to users who do not have Flash Player installed. You can configure it as per your needs.
    renderChartText= renderChartText + "\t \t" + ' Chart. ' + " \n "
    renderChartText= renderChartText + " \t </div> \n "
    #Now, we render the chart using FusionCharts Class. Each chart's instance (JavaScript) Id is named as chart_"chartId".
    renderChartText= renderChartText + "\t" + '<script type="text/javascript">' + " \n "
    #Instantiate the Chart
    renderChartText= renderChartText + "\t \t" +  'var chart_'+chartId+' = new FusionCharts("'+chartSWF+'", "'+chartId+'", "'+chartWidth.to_s+'", "'+chartHeight.to_s+'", "'+boolToNum(debugMode).to_s+'", "'+boolToNum(registerWithJS).to_s+'");' + " \n"
    if strXML==""
      #Set the dataURL of the chart
      renderChartText= renderChartText + "\t \t" +'chart_'+chartId+'.setDataURL("'+strURL+'");' + " \n "
    else
      #Provide entire XML data using dataXML method
      renderChartText= renderChartText + "\t \t" +'chart_'+chartId+'.setDataXML("'+strXML+'");' + " \n "
    end
    #Finally, render the chart.
    renderChartText= renderChartText + "\t \t" +'chart_'+chartId+'.render("'+chartId+'Div");	' + " \n "
    renderChartText= renderChartText + "\t" + '</script>' + " \n "
    renderChartText= renderChartText + " \n <!-- END Script Block for Chart " + chartId + " -->"
    return renderChartText
  end

  def boolToNum(bVal)
    if bVal==true
      intNum = 1
    else
      intNum = 0
    end
    boolToNum = intNum
  end

  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    #Generate the FlashVars string based on whether dataURL has been provided or dataXML.
    strFlashVars=''
    if strXML==""
      #DataURL Mode
      strFlashVars = "&chartWidth="+ chartWidth.to_s+ "&chartHeight=" + chartHeight.to_s + "&debugMode=" + boolToNum(debugMode).to_s + "&dataURL=" + strURL
    else
      #DataXML Mode
      strFlashVars = "&chartWidth=" + chartWidth.to_s + "&chartHeight=" +chartHeight.to_s + "&debugMode=" + boolToNum(debugMode).to_s + "&dataXML=" + strXML
    end
    renderChartText='<!-- START Code Block for Chart ' + chartId +' -->' + " \n "
    renderChartText=renderChartText+'<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="'+ chartWidth.to_s + '" height="' + chartHeight.to_s + '" id="' + chartId + '">' + " \n "
    renderChartText=renderChartText+ "\t" + '<param name="allowScriptAccess" value="always" />' + " \n "
    renderChartText=renderChartText+ "\t" + '<param name="movie" value="'+chartSWF+'"/>' + " \n "
    renderChartText=renderChartText+ "\t" + '<param name="FlashVars" value="'+strFlashVars+'" />' + " \n "
    renderChartText=renderChartText+ "\t" + '<param name="quality" value="high" />' + " \n "
    renderChartText=renderChartText+ "\t" + '<embed src="'+chartSWF+'" FlashVars="' + strFlashVars + '" quality="high" width="' + chartWidth.to_s +  '" height="'+chartHeight.to_s + '" name="' + chartId + '" allowScriptAccess="always" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />' + " \n "
    renderChartText=renderChartText+ '</object>' + " \n "
    renderChartText=renderChartText+'<!-- END Code Block for Chart ' + chartId +' -->'
    renderChartHTML=renderChartText
  end

  def acorta(valor)
    valorStr=valor.to_s
    if valorStr.length>4
      valorStr=valorStr.slice(0,4)
    end
    return valorStr
  end

  def journal(event, owner)
    record = false
    if logged_in_user and @logged_in_user.admin? and record == false
      # nothing by the moment if user is admin
    else
      journal = Journal.new
      if session[:user_id].nil?
        journal.user_id = owner
      else
        journal.user_id = session[:user_id]
      end
      journal.event= event
      journal.ip = request.remote_ip
      journal.owner_id = owner
      if request.remote_ip != '127.0.0.1' and record == false
        response = Net::HTTP.get_response('geoip1.maxmind.com', '/f?l=WAXRgRZAtHTa&i='+request.remote_ip)
        geo_ip = response.body.split(',')
        journal.country=geo_ip[0]
        journal.region=geo_ip[1]
        journal.city=geo_ip[2]
        journal.latitude=geo_ip[4]
        journal.longitude=geo_ip[5]
        journal.organization=geo_ip[9].delete('"')
      end
      journal.save
    end
  end

  def geo_ip(ip)
    response = Net::HTTP.get_response('geoip1.maxmind.com', '/f?l=WAXRgRZAtHTa&i='+ip)
    geo_ip = response.body.split(',')
    country=geo_ip[0]
    region=geo_ip[1]
    city=geo_ip[2]
    postal=geo_ip[3]
    latitude=geo_ip[4]
    longitude=geo_ip[5]
    metro_code=geo_ip[6]
    area_code=geo_ip[7]
    isp=geo_ip[8]
    organization=geo_ip[9]
    error=geo_ip[10]
  end

  def create_library(user)
    1.upto(Book::CATALOG) {|number| book = Book.new
      book.user_id = user
      book.order = number
      if number == Book::FREE
        book.browse = true
      else
        book.browse = false
      end
    book.save}
  end

  def create_avail_quest(user)
    1.upto(Quest::CATALOG) {|number| quest = Quest.new
      quest.user_id = user
      quest.order = number
      if Quest::FREE.include?(number)
        quest.browse = true
      else
        quest.browse = false
      end
    quest.save}
  end

  def get_label_quest
    titulo=[]
    titulo[0]=l(:quest1)
    titulo[1]=l(:quest2_label_0)
    titulo[2]=l(:quest3)
    titulo[3]=l(:quest4)
    titulo[4]=l(:quest5)
    titulo[5]=l(:quest6)
    titulo[6]=l(:quest7_label_0)
    titulo[7]=l(:quest8_label_0)
    titulo[8]=l(:quest9_label_0)
    titulo[9]=l(:quest10_label_0)
    titulo[10]=l(:quest11_label_0)
    titulo[11]=l(:quest12_label_0)
    return titulo
  end

  def get_label_book
    libro=[]
    libro[0]=l(:unit_1_title)
    libro[1]=l(:unit_2_title)
    libro[2]=l(:unit_3_title)
    libro[3]=l(:unit_4_title)
    libro[4]=l(:unit_5_title)
    libro[5]=l(:unit_6_title)
    libro[6]=l(:unit_7_title)
    libro[7]=l(:unit_8_title)
    libro[8]=l(:unit_9_title)
    libro[9]=l(:unit_10_title)
    libro[10]=l(:unit_11_title)
    libro[11]=l(:unit_12_title)
    libro[12]=l(:unit_13_title)
    libro[13]=l(:unit_14_title)
    libro[14]=l(:unit_15_title)
    return libro
  end

  def new_quest
    user=User.find(session[:user_id])
    user.start = Time.now
    # para quien se esta rellenando?
    if !params[:id].nil?
      user.filled_for = params[:id]
      passive = User.find_by_sql("select * from users where users.id=#{params[:id]}")
      @subject = passive[0].name
    else
      user.filled_for = session[:user_id]
    end
    user.save
  end

  def show_quest
    @answer = Answer.find(params[:id])
    @user=User.find(@answer.user_id )
    if answer_show?(@answer.user_id, @answer.browse, @user.managed_by) 
       @id = @answer.id
      @answers =[]
      resp_inicial = Answer.find(:all, :conditions  => ["created_on <= ? and user_id =? and quest_id=?",@answer.created_on,@answer.user_id,@answer.quest_id], :order  => "created_on DESC",:limit  => 5)
      respuestas = resp_inicial.reverse
      i=0
      j=0
      while (i <respuestas.length)
        if answer_show?(respuestas[i].user_id, respuestas[i].browse, @user.managed_by)
          @answers[j] = respuestas[i]
          j=j+1
        end
        i=i+1
      end
      journal( "quest"+@answer.quest_id.to_s+"/show/"+@answer.id.to_s, @answer.user_id)
      TzTime.zone=@user.timezone
      @fecha = l_datetime(TzTime.zone.utc_to_local(@answer.created_on))
    else
      flash[:notice] = l(:notice_not_authorized)
      redirect_to :controller => 'my', :action => 'page'
    end
  end

  # private
  # def set_timezone
  #   if logged_in? && !current_user.time_zone.nil?
  #     TzTime.zone = current_user.tz
  #   else
  #     TzTime.zone = TZInfo::Timezone.new(ENV['TZ'])
  #   end
  #   yield
  #   TzTime.reset!
  # end

end
