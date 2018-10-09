require 'rails_helper'

RSpec.describe Chat, type: :model do

  describe 'testing chat factory' do
    it 'can create a valid chat' do
      @chat = FactoryBot.create(:chat)
      expect(@chat).to be_valid
      expect(@chat.transactions.count).to eq(0)
    end

    it 'can have multiple transactions' do
      @chat = FactoryBot.create(:chat_with_transactions)
      expect(@chat.transactions.count).to eq(5)
    end
  end

  describe 'testing chat methods' do
    before do
      @chat = FactoryBot.create(:chat_with_transactions, transactions_count: 200)
    end

    it 'can compute total spendings' do
      @spendings = @chat.total_spendings(Date.today.month)
      expect(@spendings[:food].is_a?(Float)).to eq(true)
      expect(@spendings[:shopping].is_a?(Float)).to eq(true)
      expect(@spendings[:transport].is_a?(Float)).to eq(true)
      expect(@spendings[:misc].is_a?(Float)).to eq(true)
    end
  end

end
