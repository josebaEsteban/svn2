# Copyright (C) 2007 Teskal

class Mailer < ActionMailer::Base
  # helper IssuesHelper
  
  def account_information(user, password)
    set_language_if_valid user.language
    recipients user.mail
    from Setting.mail_from
    subject l(:mail_subject_register)
    body :user => user, :password => password
  end

  def issue_add(issue)
    set_language_if_valid(Setting.default_language)
    # Sends to all project members
    @recipients     = issue.project.members.collect { |m| m.user.mail if m.user.mail_notification }.compact
    # Sends to author and assignee (even if they turned off mail notification)
    @recipients     << issue.author.mail if issue.author
    @recipients     << issue.assigned_to.mail if issue.assigned_to
    @recipients.compact!
    @recipients.uniq!
    @from           = Setting.mail_from
    @subject        = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.status.name} - #{issue.subject}"
    @body['issue']  = issue
  end

  def issue_edit(journal)
    set_language_if_valid(Setting.default_language)
    # Sends to all project members
    issue = journal.journalized
    @recipients     = issue.project.members.collect { |m| m.user.mail if m.user.mail_notification }
    # Sends to author and assignee (even if they turned off mail notification)
    @recipients     << issue.author.mail if issue.author
    @recipients     << issue.assigned_to.mail if issue.assigned_to
    @recipients.compact!
    @recipients.uniq!
    # Watchers in cc
    @cc             = issue.watcher_recipients - @recipients
    @from           = Setting.mail_from
    @subject        = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.status.name} - #{issue.subject}"
    @body['issue']  = issue
    @body['journal']= journal
  end
  
  def document_add(document)
    set_language_if_valid(Setting.default_language)
    @recipients     = document.project.users.collect { |u| u.mail if u.mail_notification }.compact
    @from           = Setting.mail_from
    @subject        = "[#{document.project.name}] #{l(:label_document_new)}: #{document.title}"
    @body['document'] = document
  end
  
  def attachments_add(attachments)
    set_language_if_valid(Setting.default_language)
    container = attachments.first.container
    url = "http://#{Setting.host_name}/"
    added_to = ""
    case container.class.to_s
    when 'Version'
      url << "projects/list_files/#{container.project_id}"
      added_to = "#{l(:label_version)}: #{container.name}"
    when 'Document'
      url << "documents/show/#{container.id}"
      added_to = "#{l(:label_document)}: #{container.title}"
    when 'Issue'
      url << "issues/show/#{container.id}"
      added_to = "#{container.tracker.name} ##{container.id}: #{container.subject}"
    end
    @recipients     = container.project.users.collect { |u| u.mail if u.mail_notification }.compact
    @from           = Setting.mail_from
    @subject        = "[#{container.project.name}] #{l(:label_attachment_new)}"
    @body['attachments'] = attachments
    @body['url']    = url
    @body['added_to'] = added_to
  end
  
  def lost_password(token)
    set_language_if_valid(token.user.language)
    @recipients     = token.user.mail
    @from           = Setting.mail_from
    @subject        = l(:mail_subject_lost_password)
    @body['token']  = token
  end  

  def signup(token)
    set_language_if_valid(token.user.language)
    @recipients     = token.user.mail
    @from           = Setting.mail_from
    @subject        = l(:mail_subject_signup)
    @body['token']  = token
  end    
  
  def message_posted(message, recipients)
    set_language_if_valid(Setting.default_language)
    @recipients     = recipients
    @from           = Setting.mail_from
    @subject        = "[#{message.board.project.name} - #{message.board.name}] #{message.subject}"
    @body['message'] = message
  end  
  
  # def quest(ahivauno,recipient)
  #   set_language_if_valid(Setting.default_language)
  #   @recipients     = recipient
  #   @from           = Setting.mail_from
  #   @subject        = l(:mail_subject_quest)
  #   @body['ahivauno']  = ahivauno
  # end                                  
  
  def quest(answer,user) 
    set_language_if_valid(user.language)
    recipients user.mail
    subject l(:mail_subject_quest)
    body :answer => answer.quest_id,
         :answer_url => url_for(:controller => "quest"+answer.quest_id.to_s, :action => 'show', :id => answer.id)
  end     
  # 
  # private
  # def initialize_defaults(method_name)
  #   super
  #   set_language_if_valid Setting.default_language
  #   default_url_options[:host] = "www.teskal.com"
  #   default_url_options[:protocol] = "http"
  # end     
end
