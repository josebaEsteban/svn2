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



class UserPreference < ActiveRecord::Base
  belongs_to :user
  serialize :others
  
  attr_protected :others
  
  def initialize(attributes = nil)
    super
    self.others ||= {}
  end
  
  def before_save
    self.others ||= {}
  end
  
  def [](attr_name)
    if attribute_present? attr_name
      super
    else
      others ? others[attr_name] : nil
    end
  end
  
  def []=(attr_name, value)
    if attribute_present? attr_name
      super
    else
      self.others ||= {}
      self.others.store attr_name, value
    end
  end
end
