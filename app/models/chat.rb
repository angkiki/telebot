class Chat < ActiveRecord::Base
  has_many :transactions

  def self.new_chat(chat_id, username)
    Chat.create(chat_id: chat_id, username: username, command: "/done")
  end

  def self.update_command(chat, new_command)
    chat.update_attributes(command: new_command)
  end

  def total_spendings(month)
    @transactions = self.transactions.where('extract(month from created_at) = ?', month)
    @spendings = { food: 0.0, shopping: 0.0, transport: 0.0, misc: 0.0 }

    @transactions.each do |t|
      case t.category
      when '/food'
        @spendings[:food] += 1
      when '/shopping'
        @spendings[:shopping] += 1
      when '/transport'
        @spendings[:transport] += 1
      when '/misc'
        @spendings[:misc] += 1
      end
    end

    return @spendings
  end

end
