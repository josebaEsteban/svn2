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



class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :project

  validates_presence_of :role, :user, :project
  validates_uniqueness_of :user_id, :scope => :project_id

  def name
    self.user.name
  end
  
  def before_destroy
    # remove category based auto assignments for this member
    project.issue_categories.update_all "assigned_to_id = NULL", ["assigned_to_id = ?", self.user.id]
  end
end
