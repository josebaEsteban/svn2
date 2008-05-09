# Copyright (C) 2007 Teskal


class Message < ActiveRecord::Base  
  belongs_to :answer

  # def after_create
    # @board.increment! :messages_count
  # end

end
