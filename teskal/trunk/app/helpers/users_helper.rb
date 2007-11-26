# Teskal



module UsersHelper
  def status_options_for_select(selected)
    options_for_select([[l(:label_all), "*"], 
                        [l(:status_active), 1],
                        [l(:status_registered), 2],
                        [l(:status_locked), 3]], selected)
  end
end
