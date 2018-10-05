require 'rails_helper'

RSpec.describe TelebotController, type: :controller do

  describe "Testing Telebot's Private Methods" do

    before do
      @telebot = TelebotController.new
    end

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
      @telebot.instance_eval{ parse_incoming_text('/food@angkiki_bot') }.should eq(['/food'])
      @telebot.instance_eval{ parse_incoming_text('/save') }.should eq(['/save'])
      @telebot.instance_eval{ parse_incoming_text('/save 100 food') }.should eq(['/save', '100 food'])
      @telebot.instance_eval{ parse_incoming_text('/save@angkiki_bot 100 food') }.should eq(['/save', '100 food'])

      #edge cases
      @telebot.instance_eval{ parse_incoming_text('/poo') }.should eq(false)
      @telebot.instance_eval{ parse_incoming_text('/poo@angkiki_bot') }.should eq(false)
    end

    it "Can handle command sequences - @check_command_sequence(current_command, incoming_command, chat)" do
      # create the new chat object first
      CHAT = Chat.create(chat_id: 414715659, username: 'angkiki', command: '/done')

      # ~ ~ ~ when current_command is /done ~ ~ ~

      # testing /cancel
      @done_cancel_response = "Hi #{CHAT.username}, you have no ongoing commands with Fwenny, so I have nothing to cancel!"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/cancel'], CHAT) }.should eq(@done_cancel_response)

      # testing /save
      @done_save_response = "Hi #{CHAT.username}, you have not initiated a new budget sequence. Please send Fwenny either /food, /shopping, /transport or /misc to start a new sequence."
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save'], CHAT) }.should eq(@done_save_response)

      # initiating new budget sequence - /food
      @done_food_response = "Hi #{CHAT.username}, you have initiated the /food sequence. Please reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/food'], CHAT) }.should eq(@done_food_response)

      # expect CHAT's command to be updated
      expect(CHAT.command).to eq('/food')

      # ~ ~ ~ current_command is now /food ~ ~ ~

      #currently, default response if sequence is food is feature not built yet
      @unbuilt_response = "Hi #{CHAT.username}, this feature is a work in progress!"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/save'], CHAT) }.should eq(@unbuilt_response)

      # but can cancel if we are in initiated sequence
      @cancel_response = "Hi #{CHAT.username}, you have cancelled the current sequence - #{CHAT.command}"
      @telebot.instance_eval{ check_command_sequence(CHAT.command, ['/cancel'], CHAT) }.should eq(@cancel_response)
    end
  end
end
