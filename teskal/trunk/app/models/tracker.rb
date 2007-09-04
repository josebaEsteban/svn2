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



class Tracker < ActiveRecord::Base
  before_destroy :check_integrity  
  has_many :issues
  has_many :workflows, :dependent => :delete_all
  has_and_belongs_to_many :custom_fields, :class_name => 'IssueCustomField', :join_table => "#{table_name_prefix}custom_fields_trackers#{table_name_suffix}", :association_foreign_key => 'custom_field_id'
  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i

private
  def check_integrity
    raise "Can't delete tracker" if Issue.find(:first, :conditions => ["tracker_id=?", self.id])
  end
end
