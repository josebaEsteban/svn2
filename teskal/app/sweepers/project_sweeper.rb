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



class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project

  def before_save(project)
    if project.new_record?
      expire_cache_for(project.parent) if project.parent
    else
      project_before_update = Project.find(project.id)
      return if project_before_update.parent_id == project.parent_id && project_before_update.status == project.status
      expire_cache_for(project.parent) if project.parent      
      expire_cache_for(project_before_update.parent) if project_before_update.parent
    end
  end
  
  def after_destroy(project)
    expire_cache_for(project.parent) if project.parent
  end
          
private
  def expire_cache_for(project)
    expire_fragment(Regexp.new("projects/(calendar|gantt)/#{project.id}\\."))
  end
end
