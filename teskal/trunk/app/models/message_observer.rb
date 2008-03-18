# Copyright (C) 2007 Teskal

class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    # send notification to board watchers
    # recipients = message.board.watcher_recipients
    # Mailer.deliver_message_posted(message, recipients) unless recipients.empty?
  end
end
