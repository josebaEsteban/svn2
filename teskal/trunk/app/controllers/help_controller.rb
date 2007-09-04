# Teskal


#

# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 


# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License



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
