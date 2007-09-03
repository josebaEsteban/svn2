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



class IssueCategory < ActiveRecord::Base
  before_destroy :check_integrity  
  belongs_to :project
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]
  
private
  def check_integrity
    raise "Can't delete category" if Issue.find(:first, :conditions => ["category_id=?", self.id])
  end
end
