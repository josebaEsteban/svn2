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



class Role < ActiveRecord::Base
  before_destroy :check_integrity  
  has_and_belongs_to_many :permissions
  has_many :workflows, :dependent => :delete_all
  has_many :members
  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i

  def <=>(role)
    position <=> role.position
  end
  
private
  def check_integrity
    raise "Can't delete role" if Member.find(:first, :conditions =>["role_id=?", self.id])
  end
end
