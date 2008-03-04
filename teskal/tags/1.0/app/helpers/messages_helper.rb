# Copyright (C) 2007 Teskal



module MessagesHelper

  def link_to_message(message)
    return '' unless message
    link_to h(truncate(message.subject, 60)), :controller => 'messages',
                                           :action => 'show',
                                           :board_id => message.board_id,
                                           :id => message.root,
                                           :anchor => (message.parent_id ? "message-#{message.id}" : nil)
  end
end
