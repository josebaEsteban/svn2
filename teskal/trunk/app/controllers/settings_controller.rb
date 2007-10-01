# Teskal
# Copyright (C) 2007 Teskal


class SettingsController < ApplicationController
  layout 'base'	
  before_filter :require_admin
  
  def index
    edit
    render :action => 'edit'
  end

  def edit
    if request.post? and params[:settings] and params[:settings].is_a? Hash
      params[:settings].each { |name, value| Setting[name] = value }
      redirect_to :action => 'edit' and return
    end
    @textile_available = ActionView::Helpers::TextHelper.method_defined?("textilize")
  end
end
