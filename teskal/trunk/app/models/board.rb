# Teskal

# Copyright (C) 2007 Teskal
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



class Board < ActiveRecord::Base
  belongs_to :project
  has_many :topics, :class_name => 'Message', :conditions => "#{Message.table_name}.parent_id IS NULL", :order => "#{Message.table_name}.created_on DESC"
  has_many :messages, :dependent => :delete_all, :order => "#{Message.table_name}.created_on DESC"
  belongs_to :last_message, :class_name => 'Message', :foreign_key => :last_message_id
  acts_as_list :scope => :project_id
  acts_as_watchable
  
  validates_presence_of :name, :description
  validates_length_of :name, :maximum => 30
  validates_length_of :description, :maximum => 255
end
