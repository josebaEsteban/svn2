class Test5Controller < ApplicationController
  layout 'base'
  before_filter :require_login
  
  def new
    @answer = Answer.new
  end
end
