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



class IssueSweeper < ActionController::Caching::Sweeper
  observe Issue

  def after_save(issue)
    expire_cache_for(issue)
  end
  
  def after_destroy(issue)
    expire_cache_for(issue)
  end
          
private
  def expire_cache_for(issue)
    # fragments of the main project
    expire_fragment(Regexp.new("projects/(calendar|gantt)/#{issue.project_id}\\."))
    # fragments of the root project that include subprojects issues
    unless issue.project.parent_id.nil?
      expire_fragment(Regexp.new("projects/(calendar|gantt)/#{issue.project.parent_id}\\..*subprojects"))
    end
  end
end
