# Teskal


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



class Document < ActiveRecord::Base
  belongs_to :project
  belongs_to :category, :class_name => "Enumeration", :foreign_key => "category_id"
  has_many :attachments, :as => :container, :dependent => :destroy

  validates_presence_of :project, :title, :category
end
