class Answer < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :answ2, :on => :create, :message => "can't be blank"
end
