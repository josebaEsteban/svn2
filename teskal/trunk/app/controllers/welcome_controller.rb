# Teskal
# Copyright (C)2007  Teskal 


class WelcomeController < ApplicationController
  layout 'base'

  def index
    # @projects = Project.latest logged_in_user
     @answers = Answer.find_by_user_id(session[:user_id])
     puts session[:user_id] 
     puts  @answers     
      end  
  
  def en
    set_language_if_valid ('es')
    redirect_to :controller  => 'test2', :action => 'show', :id => 22
  end 

    def list
     @answer = Answer.find_by_user_id(5)      
     @answer_pages, @answers = paginate :answers, :per_page => 40
    end

end
