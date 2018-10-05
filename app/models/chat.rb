class Chat < ActiveRecord::Base

  def self.new_chat(chat_id, username)
    Chat.create(chat_id: chat_id, username: username, command: "/done")
  end

  def self.update_command(chat, new_command)
    chat.update_attributes(command: new_command)
  end

end
