# Teskal
# Copyright (C) 2007 Teskal


class SysController < ActionController::Base
  wsdl_service_name 'Sys'
  web_service_api SysApi
  web_service_scaffold :invoke
  
  before_invocation :check_enabled
  
  def projects
    Project.find(:all, :include => :repository)
  end

  def repository_created(project_id, url)
    project = Project.find_by_id(project_id)
    return 0 unless project && project.repository.nil?
    logger.debug "Repository for #{project.name} created"
    repository = Repository.new(:project => project, :url => url)
    repository.root_url = url
    repository.save
    repository.id
  end

protected

  def check_enabled(name, args)
    Setting.sys_api_enabled?
  end
end
