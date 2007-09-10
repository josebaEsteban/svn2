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

 
protected

  def check_enabled(name, args)
    Setting.sys_api_enabled?
  end
end
