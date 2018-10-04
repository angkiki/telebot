class Chat < ActiveRecord::Base

  def self.new_chat(chat_id, username)
    Chat.create(chat_id: chat_id, username: username, command: "/done")
  end

end
