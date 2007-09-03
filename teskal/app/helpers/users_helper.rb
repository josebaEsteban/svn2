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



module UsersHelper
  def status_options_for_select(selected)
    options_for_select([[l(:label_all), "*"], 
                        [l(:status_active), 1],
                        [l(:status_registered), 2],
                        [l(:status_locked), 3]], selected)
  end
end
