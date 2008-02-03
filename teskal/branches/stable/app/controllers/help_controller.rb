# Teskal




class HelpController < ApplicationController

  skip_before_filter :check_if_login_required
  before_filter :load_help_config

  # displays help page for the requested controller/action
  def index	
    # select help page to display
    if params[:ctrl] and @help_config['pages'][params[:ctrl]]
      if params[:page] and @help_config['pages'][params[:ctrl]][params[:page]]
        template = @help_config['pages'][params[:ctrl]][params[:page]]
      else
        template = @help_config['pages'][params[:ctrl]]['index']
      end
    end
    # choose language according to available help translations
    lang = (@help_config['langs'].include? current_language.to_s) ? current_language.to_s : @help_config['langs'].first
	
    url = "/manual/#{lang}/" + (template || "index.html")
    redirect_to(request.relative_url_root + url)
  end

private
  def load_help_config
    @help_config = YAML::load(File.open("#{RAILS_ROOT}/config/help.yml"))
  end	
end
