# Copyright (C) 2007 Teskal


class Message < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  def after_create
    # @board.increment! :messages_count
  end

end
