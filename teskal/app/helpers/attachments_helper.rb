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



module AttachmentsHelper
  # displays the links to a collection of attachments
  def link_to_attachments(attachments, options = {})
    if attachments.any?
      render :partial => 'attachments/links', :locals => {:attachments => attachments, :options => options}
    end
  end
end
