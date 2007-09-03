# Teskal
# Copyright (C)2007  Teskal 


class WelcomeController < ApplicationController
  layout 'base'

  def index
    @news = News.latest logged_in_user
    @projects = Project.latest logged_in_user
  end
end
