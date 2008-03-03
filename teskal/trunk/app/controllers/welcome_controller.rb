# Copyright (C)2007  Teskal


class WelcomeController < ApplicationController
  layout 'base'
  skip_before_filter :check_if_login_required, :only => [:signup_done, :index, :lost_email_sent]
  def index

    # @projects = Project.laquest logged_in_user
    # @answers = Answer.find_by_user_id('21')
    # redirect_to :controller => 'account', :action => 'login'
  end


  def signup_done
  end

  def lost_email_sent
  end

end
