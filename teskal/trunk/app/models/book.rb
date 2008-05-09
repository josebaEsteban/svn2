class Book < ActiveRecord::Base 
belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  CATALOG = 15
  FREE = [4]
end
