class Quest < ActiveRecord::Base
  CATALOG = 16
  FREE = [2,12]
  belongs_to :user
end
