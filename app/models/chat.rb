class Chat < ActiveRecord::Base

  def self.new_chat(chat_id)
    Chat.create(chat_id: chat_id, command: "/done")
  end
  
end
