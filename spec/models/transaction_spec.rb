require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "Transaction ActiveRecord Callback" do
    before do
      @chat = Chat.create(chat_id: 98435, username: 'angkiki', command: '/done')
    end

    it "Validates the amount saved" do
      @t = Transaction.new(category: '/food', amount: 0, description: 'hello', chat: @chat)
      expect(@t.save).to eq(false)
    end
  end
end
