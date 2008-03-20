# Copyright (C) 2007 Teskal


class Mailer < ActionMailer::Base

  QUEST_NEW = 1
  QUEST_ALLOWED = 2
  QUEST_PENDING = 3
  BOOK_ALLOWED = 4
  helper ApplicationHelper
  # helper IssuesHelper
  # helper CustomFieldsHelper

  include ActionController::UrlWriter

  def issue_add(issue)
    recipients issue.recipients
    subject "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.status.name} - #{issue.subject}"
    body :issue => issue,
    :issue_url => url_for(:controller => 'issues', :action => 'show', :id => issue)
  end

  def issue_edit(journal)
    issue = journal.journalized
    recipients issue.recipients
    # Watchers in cc
    cc(issue.watcher_recipients - @recipients)
    subject "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.status.name} - #{issue.subject}"
    body :issue => issue,
    :journal => journal,
    :issue_url => url_for(:controller => 'issues', :action => 'show', :id => issue)
  end

  def document_added(document)
    recipients document.project.recipients
    subject "[#{document.project.name}] #{l(:label_document_new)}: #{document.title}"
    body :document => document,
    :document_url => url_for(:controller => 'documents', :action => 'show', :id => document)
  end

  def attachments_added(attachments)
    container = attachments.first.container
    added_to = ''
    added_to_url = ''
    case container.class.name
    when 'Version'
      added_to_url = url_for(:controller => 'projects', :action => 'list_files', :id => container.project_id)
      added_to = "#{l(:label_version)}: #{container.name}"
    when 'Document'
      added_to_url = url_for(:controller => 'documents', :action => 'show', :id => container.id)
      added_to = "#{l(:label_document)}: #{container.title}"
    end
    recipients container.project.recipients
    subject "[#{container.project.name}] #{l(:label_attachment_new)}"
    body :attachments => attachments,
    :added_to => added_to,
    :added_to_url => added_to_url
  end

  def news_added(news)
    recipients news.project.recipients
    subject "[#{news.project.name}] #{l(:label_news)}: #{news.title}"
    body :news => news,
    :news_url => url_for(:controller => 'news', :action => 'show', :id => news)
  end

  def account_information(user, password)
    set_language_if_valid user.language
    recipients user.mail
    subject l(:mail_subject_signup)
    body :user => user,
    :password => password,
    :login_url => url_for(:controller => 'account', :action => 'login')
  end

  def account_activation_request(user)
    # Send the email to all active administrators
    recipients User.find_active(:all, :conditions => {:admin => true}).collect { |u| u.mail }.compact
    subject l(:mail_subject_account_activation_request)
    body :user => user,
    :url => url_for(:controller => 'users', :action => 'index', :status => User::STATUS_REGISTERED, :sort_key => 'created_on', :sort_order => 'desc')
  end

  def lost_password(token)
    set_language_if_valid(token.user.language)
    recipients token.user.mail
    subject l(:mail_subject_lost_password)
    body :token => token,
    :url => url_for(:controller => 'account', :action => 'lost_password', :token => token.value)
  end

  def signup(token)
    set_language_if_valid(token.user.language)
    recipients token.user.mail
    subject l(:mail_subject_signup)
    body :token => token,
    :url => url_for(:controller => 'account', :action => 'activate', :token => token.value)
  end

  def test(user)
    set_language_if_valid(user.language)
    recipients user.mail
    subject 'Teskal test'
    body :url => url_for(:controller => 'welcome')
  end

  def message_posted(from,to,message)
    recipients to.mail
    subject l(:label_message_from)+" "+from.name
    body :origin  => from.name,
    :destination  => to.name,
    :message => message
  end

  def quest(answer,manager,athlete,type)
    quest_name = ""
    @type = type
    competicion = ""
    notas = ""
    case @type
    when QUEST_NEW
      set_language_if_valid(manager.language)
      recipients manager.mail
      subject l(:mail_subject_quest)
      quest_name = get_title_quest(answer.quest_id)
      competicion = answer.competition
      if competicion.nil?
        competicion = ""
      end
      notas = answer.note_to_mail
      body :who => athlete.name,
      :text  => " " + l(:mail_body_quest1),
      :which  => quest_name,
      :competition  => competicion,
      :notes  => notas,
      :url => url_for(:controller => "quest"+answer.quest_id.to_s, :action => 'show', :id => answer.id)

    when QUEST_ALLOWED
      set_language_if_valid(athlete.language)
      recipients athlete.mail
      subject l(:mail_subject_allowed)
      quest_name = get_title_quest(answer.quest_id)
      body :who => "",
      :text  => l(:mail_body_quest3),
      :which  => quest_name,
      :competition  => competicion,
      :notes  => notas,
      :url => url_for(:controller => "quest"+answer.quest_id.to_s, :action => 'show', :id => answer.id)
    when QUEST_PENDING
      set_language_if_valid(athlete.language)
      recipients athlete.mail
      subject l(:mail_subject_pending)
      quest_name = get_title_quest(answer.order)
      body :who => "",
      :text  => l(:mail_body_quest4),
      :which  => quest_name,
      :competition  => competicion,
      :notes  => notas,
      :url => url_for(:controller => "quest"+answer.order.to_s, :action => 'new')
    end
  end

  def book(book,athlete)
    set_language_if_valid(athlete.language)
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
    recipients athlete.mail
    subject l(:mail_subject_book)
    body :who => athlete.name,
    :which  => libro[book.order-1]
  end

  def get_title_quest(selector)
    case selector
    when 1
      quest_name = l(:quest1)
    when 2
      quest_name = l(:quest2)
    when 3
      quest_name = l(:quest3)
    when 4
      quest_name = l(:quest4)
    when 5
      quest_name = l(:quest5)
    when 6
      quest_name = l(:quest6)
    when 7
      quest_name = l(:quest7)
    when 8
      quest_name = l(:quest8)
    when 9
      quest_name = l(:quest9)
    when 10
      quest_name = l(:quest10)
    when 11
      quest_name = l(:quest11)
    when 12
      quest_name = l(:quest12)
    when 13
      quest_name = l(:quest13)
    when 14
      quest_name = l(:quest14)
    when 15
      quest_name = l(:quest15)
    end
  end

  private
  def initialize_defaults(method_name)
    super
    set_language_if_valid Setting.default_language
    from Setting.mail_from
    default_url_options[:host] = Setting.host_name
    default_url_options[:protocol] = Setting.protocol
  end

  # Overrides the create_mail method
  def create_mail
    # Removes the current user from the recipients and cc
    # if he doesn't want to receive notifications about what he does
    # if User.current.pref[:no_self_notified]
    #   recipients.delete(User.current.mail) if recipients
    #   cc.delete(User.current.mail) if cc
    # end
    # # Blind carbon copy recipients
    # if Setting.bcc_recipients?
    #   bcc([recipients, cc].flatten.compact.uniq)
    #   recipients []
    #   cc []
    # end
    super
  end

  # Renders a message with the corresponding layout
  def render_message(method_name, body)
    layout = method_name.match(%r{text\.html\.(rhtml|rxml)}) ? 'layout.text.html.rhtml' : 'layout.text.plain.rhtml'
    body[:content_for_layout] = render(:file => method_name, :body => body)
    ActionView::Base.new(template_root, body, self).render(:file => "mailer/#{layout}")
  end

  # Makes partial rendering work with Rails 1.2 (retro-compatibility)
  def self.controller_path
    ''
  end unless respond_to?('controller_path')
end
