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



class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles

  validates_presence_of :controller, :action, :description

  GROUPS = {
    100 => :label_project,
    200 => :label_member_plural,
    1500 => :label_time_tracking,


  }.freeze
  
  @@cached_perms_for_public = nil
  @@cached_perms_for_roles = nil
  
  def name
    self.controller + "/" + self.action
  end
  
  def group_id
    (self.sort / 100)*100
  end
  
  def self.allowed_to_public(action)
    @@cached_perms_for_public ||= find(:all, :conditions => ["is_public=?", true]).collect {|p| "#{p.controller}/#{p.action}"}
    @@cached_perms_for_public.include? action
  end
  
  def self.allowed_to_role(action, role)
    @@cached_perms_for_roles ||=
      begin
        perms = {}
        find(:all, :include => :roles).each {|p| perms.store "#{p.controller}/#{p.action}", p.roles.collect {|r| r.id } }
        perms
      end
    allowed_to_public(action) or (role && @@cached_perms_for_roles[action] && @@cached_perms_for_roles[action].include?(role.id))
  end
  
  def self.allowed_to_role_expired
    @@cached_perms_for_roles = nil
  end
end
