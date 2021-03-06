# Copyright (C) 2007 Teskal


class Message < ActiveRecord::Base
  belongs_to :board
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  acts_as_tree :counter_cache => :replies_count, :order => "#{Message.table_name}.created_on ASC"
  has_many :attachments, :as => :container, :dependent => :destroy
  belongs_to :last_reply, :class_name => 'Message', :foreign_key => 'last_reply_id'
  
  validates_presence_of :subject, :content
  validates_length_of :subject, :maximum => 255
  
  def after_create
    board.update_attribute(:last_message_id, self.id)
    board.increment! :messages_count
    if parent
      parent.reload.update_attribute(:last_reply_id, self.id)
    else
      board.increment! :topics_count
    end
  end
  
  def project
    board.project
  end
end
