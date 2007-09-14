# Teskal

# Copyright (C) 2007 Teskal
#

# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 


# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License



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
