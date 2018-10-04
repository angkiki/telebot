class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :chat_id
      t.integer :username
      t.string :command
    end
  end
end
