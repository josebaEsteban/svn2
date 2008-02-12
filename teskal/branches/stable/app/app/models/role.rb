# Teskal



class Role < ActiveRecord::Base
  before_destroy :check_integrity  
  has_and_belongs_to_many :permissions
  has_many :workflows, :dependent => :delete_all
  has_many :members
  # acts_as_list

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
