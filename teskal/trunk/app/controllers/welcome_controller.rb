# Copyright (C)2007  Teskal


class WelcomeController < ApplicationController
  layout 'base'

  def index
    # @projects = Project.laquest logged_in_user
    @answers = Answer.find_by_user_id(session[:user_id])
  end

  def list
    @answers = Answer.find_by_sql("select * from answers where answers.user_id=#{session[:user_id]} order by answers.created_on DESC")
    # @answer_pages, @answers = paginate :answers, :per_page => 40
  end

end
