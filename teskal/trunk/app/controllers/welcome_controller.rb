# Teskal
# Copyright (C)2007  Teskal 


class WelcomeController < ApplicationController
  layout 'base'

  def index
    @projects = Project.latest logged_in_user
  end
  
  def en
    set_language_if_valid ('es')
    redirect_to :controller  => 'test2', :action => 'show', :id => 22
  end
end
