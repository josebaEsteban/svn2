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



class JournalDetail < ActiveRecord::Base
  belongs_to :journal
  
  def before_save
    self.value = value[0..254] if value && value.is_a?(String)
    self.old_value = old_value[0..254] if old_value && old_value.is_a?(String)
  end
end
