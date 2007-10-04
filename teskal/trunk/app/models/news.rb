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



class News < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  
  validates_presence_of :title, :description
  
  # returns laquest news for projects visible by user
  def self.laquest(user=nil, count=5)
    find(:all, :limit => count, :conditions => Project.visible_by(user), :include => [ :author, :project ], :order => "#{News.table_name}.created_on DESC")	
  end
end
