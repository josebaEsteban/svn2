# Copyright (C)2007  Teskal


class WelcomeController < ApplicationController
  layout 'base'
    skip_before_filter :check_if_login_required, :only => [:signup_done, :index] 
  def index
    # @projects = Project.laquest logged_in_user
    @answers = Answer.find_by_user_id('21')
    # redirect_to :controller => 'account', :action => 'login'

  end

  def list
    @answers = Answer.find_by_sql("select * from answers where answers.user_id=#{session[:user_id]} order by answers.created_on DESC")
    # @answer_pages, @answers = paginate :answers, :per_page => 40
  end

  def signup_done
  end

end
