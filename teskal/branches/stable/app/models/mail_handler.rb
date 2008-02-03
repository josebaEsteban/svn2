# Copyright (C) 2007 Teskal



class MailHandler < ActionMailer::Base
  
  # Processes incoming emails
  # Currently, it only supports adding a note to an existing issue
  # by replying to the initial notification message
  def receive(email)
    # find related issue by parsing the subject
    m = email.subject.match %r{\[.*#(\d+)\]}
    return unless m
    issue = Issue.find_by_id(m[1])
    return unless issue
    
    # find user
    user = User.find_active(:first, :conditions => {:mail => email.from.first})
    return unless user
    # check permission
    return unless Permission.allowed_to_role("issues/add_note", user.role_for_project(issue.project))
    
    # add the note
    issue.init_journal(user, email.body.chomp)
    issue.save
  end
end
