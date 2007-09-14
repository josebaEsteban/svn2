# Teskal

# Copyright (C) 2007 Teskal


class SysApi < ActionWebService::API::Base
  api_method :projects,
             :expects => [],
             :returns => [[Project]]
  api_method :repository_created,
             :expects => [:int, :string],
             :returns => [:int]
end
