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



class Project < ActiveRecord::Base
  # Project statuses
  STATUS_ACTIVE     = 1
  STATUS_ARCHIVED   = 9
  
  has_many :members, :dependent => :delete_all, :include => :user, :conditions => "#{User.table_name}.status=#{User::STATUS_ACTIVE}"
  has_many :users, :through => :members

  has_many :time_entries, :dependent => :delete_all

  acts_as_tree :order => "name", :counter_cache => true
  
  attr_protected :status
  
  validates_presence_of :name, :description, :identifier
  validates_uniqueness_of :name, :identifier

  validates_length_of :name, :maximum => 30
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i
  validates_length_of :description, :maximum => 255
  validates_length_of :identifier, :in => 3..12
  validates_format_of :identifier, :with => /^[a-z0-9\-]*$/
  
  def identifier=(identifier)
    super unless identifier_frozen?
  end
  
  def identifier_frozen?
    errors[:identifier].nil? && !(new_record? || identifier.blank?)
  end
  
  
  # returns latest created projects
  # non public projects will be returned only if user is a member of those
  def self.latest(user=nil, count=5)
    find(:all, :limit => count, :conditions => visible_by(user), :order => "created_on DESC")	
  end	

  def self.visible_by(user=nil)
    if user && user.admin?
      return ["#{Project.table_name}.status=#{Project::STATUS_ACTIVE}"]
    elsif user && user.memberships.any?
      return ["#{Project.table_name}.status=#{Project::STATUS_ACTIVE} AND (#{Project.table_name}.is_public = ? or #{Project.table_name}.id IN (#{user.memberships.collect{|m| m.project_id}.join(',')}))", true]
    else
      return ["#{Project.table_name}.status=#{Project::STATUS_ACTIVE} AND #{Project.table_name}.is_public = ?", true]
    end
  end
  
  def active?
    self.status == STATUS_ACTIVE
  end
  
  def archive
    # Archive subprojects if any
    children.each do |subproject|
      subproject.archive
    end
    update_attribute :status, STATUS_ARCHIVED
  end
  
  def unarchive
    return false if parent && !parent.active?
    update_attribute :status, STATUS_ACTIVE
  end
  
  def active_children
    children.select {|child| child.active?}
  end
  
   
protected
  def validate
    errors.add(parent_id, " must be a root project") if parent and parent.parent
    errors.add_to_base("A project with subprojects can't be a subproject") if parent and children.size > 0
  end
end
