# Copyright (C) 2007 Teskal


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
