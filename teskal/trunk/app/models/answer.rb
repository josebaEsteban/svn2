class Answer < ActiveRecord::Base
  belongs_to :user
  # before_create :fix_timezone
  # tz_time_attributes :created_on 
  # def created_on
  #     d = read_attribute(:created_on)
  #     
  #     if d.utc?
  #       write_attribute :created_on, TzTime.at(Time.at(TzTime.zone.utc_to_local(d)))
  #     else
  #       d
  #     end
  #   end 
  # protected
  #   def fix_timezone
  #     self.created_on = TzTime.at(created_on)
  #   end  
end
