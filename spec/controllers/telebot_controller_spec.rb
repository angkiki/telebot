require 'rails_helper'

RSpec.describe TelebotController, type: :controller do

  before do
    @telebot = TelebotController.new
  end

  describe "Testing @telebot's Private Methods" do
    it "Can check for valid commands - @accepted_commands(command)" do
      # base cases
      @telebot.instance_eval{ accepted_commands('/food') }.should eq(0)
      @telebot.instance_eval{ accepted_commands('/save') }.should eq(4)

      # edge cases
      @telebot.instance_eval{ accepted_commands('/poopoo') }.should eq(nil)
    end

    it "Can parse incoming test - @parse_incoming_text(text)" do
      # base cases
      @telebot.instance_eval{ parse_incoming_text('/food') }.should eq(['/food'])
      @telebot.instance_eval{ parse_incoming_text('/food@Fwenny_bot') }.should eq(['/food'])
      @telebot.instance_eval{ parse_incoming_text('/save') }.should eq(['/save'])
      @telebot.instance_eval{ parse_incoming_text('/save 100 food') }.should eq(['/save', '100 food'])
      @telebot.instance_eval{ parse_incoming_text('/save@Fwenny_bot 100 food') }.should eq(['/save', '100 food'])

      #edge cases
      @telebot.instance_eval{ parse_incoming_text('/poo') }.should eq(false)
      @telebot.instance_eval{ parse_incoming_text('/poo@Fwenny_bot') }.should eq(false)
    end

    it "Can handle command sequences - @check_command_sequence(current_command, incoming_command, chat)" do
      # create the new chat object first
      CHAT = Chat.create(chat_id: 414715659, username: 'angkiki', command: '/done')

      # ~ ~ ~ when current_command is /done ~ ~ ~

      # testing /cancel
      done_cancel_response = "Hi #{CHAT.username}, you have no ongoing commands with Fwenny, so I have nothing to cancel!"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/cancel'], CHAT) }.should eq(done_cancel_response)

      # testing /save
      done_save_response = "Hi #{CHAT.username}, you have not initiated a new budget sequence. Please send Fwenny either /food, /shopping, /transport or /misc to start a new sequence."
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save'], CHAT) }.should eq(done_save_response)

      # initiating new budget sequence - /food
      done_food_response = "Hi #{CHAT.username}, you have initiated the /food sequence. Please reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/food'], CHAT) }.should eq(done_food_response)

      # expect CHAT's command to be updated
      expect(CHAT.command).to eq('/food')

      # ~ ~ ~ current_command is now /food ~ ~ ~

      # testing /save error(edge) cases first
      error_save_response = "Hi #{CHAT.username}, you need to reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save'], CHAT) }.should eq(error_save_response)

      error_save_response2 = "Hi #{CHAT.username}, you need to reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save', 'abc food for lunch'], CHAT) }.should eq(error_save_response2)

      # testing /save responses
      save_response = "Hi #{CHAT.username}, you are recording the following transaction: /food - $100.0 for: food for lunch."
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save', '100 food for lunch'], CHAT) }.should eq(save_response)

      # expect a new transaction to be created
      expect(Transaction.last).to_not eq(nil)
      expect(Transaction.last.amount).to eq(100.0)
      expect(Transaction.last.category).to eq('/food')
      expect(CHAT.transactions.count).to eq(1)
      expect(CHAT.transactions.last).to eq(Transaction.last)

      # expect CHAT's command to be updated
      expect(CHAT.command).to eq('/done')

      id_response = "Hi #{CHAT.username}, your telegram id is: #{CHAT.chat_id}"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/id'], CHAT) }.should eq(id_response)
    end
  end
end
