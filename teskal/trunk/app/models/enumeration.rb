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



class Enumeration < ActiveRecord::Base
  before_destroy :check_integrity
  
  validates_presence_of :opt, :name
  validates_uniqueness_of :name, :scope => [:opt]
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i
	
	OPTIONS = {
	  "IPRI" => :enumeration_issue_priorities,
      "DCAT" => :enumeration_doc_categories,
      "ACTI" => :enumeration_activities
	}.freeze
	
	def self.get_values(option)
		find(:all, :conditions => ['opt=?', option])
	end
	
  def option_name
    OPTIONS[self.opt]
  end
  
private
  def check_integrity
    case self.opt
    when "IPRI"
      raise "Can't delete enumeration" if Issue.find(:first, :conditions => ["priority_id=?", self.id])
    when "DCAT"
      raise "Can't delete enumeration" if Document.find(:first, :conditions => ["category_id=?", self.id])
    when "ACTI"
      raise "Can't delete enumeration" if TimeEntry.find(:first, :conditions => ["activity_id=?", self.id])
    end
  end
end
