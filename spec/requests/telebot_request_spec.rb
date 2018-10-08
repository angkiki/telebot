require 'rails_helper'

describe "Making POST to telebot#telebot_webhook" do

  before do
    @cancel_params = {
      "update_id" => 205393243, "message" => {
        "message_id" => 140, "from" => {
          "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
        }, "chat" => {
          "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
        }, "date" => 1538724246, "text" => "/cancel", "entities" => [{
          "offset" => 0,
          "length" => 7,
          "type" => "bot_command"
        }]
      }, "telebot" => {
        "update_id" => 205393243, "message" => {
          "message_id" => 140, "from" => {
            "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
          }, "chat" => {
            "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
          }, "date" => 1538724246, "text" => "/cancel", "entities" => [{
            "offset" => 0,
            "length" => 7,
            "type" => "bot_command"
          }]
        }
      }
    }

    @food_params = {
      "update_id" => 205393243, "message" => {
        "message_id" => 140, "from" => {
          "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
        }, "chat" => {
          "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
        }, "date" => 1538724246, "text" => "/food", "entities" => [{
          "offset" => 0,
          "length" => 7,
          "type" => "bot_command"
        }]
      }, "telebot" => {
        "update_id" => 205393243, "message" => {
          "message_id" => 140, "from" => {
            "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
          }, "chat" => {
            "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
          }, "date" => 1538724246, "text" => "/food", "entities" => [{
            "offset" => 0,
            "length" => 7,
            "type" => "bot_command"
          }]
        }
      }
    }

    @save_params = {
      "update_id" => 205393243, "message" => {
        "message_id" => 140, "from" => {
          "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
        }, "chat" => {
          "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
        }, "date" => 1538724246, "text" => "/save 100 chicken rice for lunch", "entities" => [{
          "offset" => 0,
          "length" => 7,
          "type" => "bot_command"
        }]
      }, "telebot" => {
        "update_id" => 205393243, "message" => {
          "message_id" => 140, "from" => {
            "id" => 414715659, "is_bot" => false, "first_name" => "Gabriel", "last_name" => "Ang", "username" => "angkiki", "language_code" => "en-SG"
          }, "chat" => {
            "id" => -317738971, "title" => "PPK & PPQ", "type" => "group", "all_members_are_administrators" => true
          }, "date" => 1538724246, "text" => "/save 100 chicken rice for lunch", "entities" => [{
            "offset" => 0,
            "length" => 7,
            "type" => "bot_command"
          }]
        }
      }
    }
  end

  describe "testing edge case" do

    it "should have a 422 response code for a post without params['message']" do
      post '/telebot-webhook'
      expect(response).to have_http_status(422)
    end

    it "should have a 422 response code for a post with params['message'] but no other valid keys" do
      post '/telebot-webhook', params: { message: 'there is a message key in params' }
      expect(response).to have_http_status(200)
    end

  end

  describe "testing 1st time POST" do
    before do
      post '/telebot-webhook', params: @cancel_params
    end

    it "should have a 200 status code and have the first timer response" do
      # the first post, user is new
      expect(response).to have_http_status(200)
      expect(response.parsed_body['text']).to eq("Hello! I see that you're new here. Welcome to Angkiki's Telebot :)")
    end
  end

  describe "testing subsequent POST" do
    before do
      @chat = Chat.create(chat_id: 414715659, username: 'angkiki', command: '/done')
      post '/telebot-webhook', params: @food_params
    end

    it "should be able to initiate and perform a save sequence" do
      # initiating /food sequence
      expect(response).to have_http_status(200)
      expect(response.parsed_body['text']).to eq("Hi angkiki, you have initiated the /food sequence. Please reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction")

      # command updates accordingly
      expect(Chat.find_by(username: 'angkiki').command).to eq('/food')

      # sending /save
      post '/telebot-webhook', params: @save_params
      expect(response.parsed_body['text']).to eq("Hi angkiki, you are recording the following transaction: /food - $100.0 for: chicken rice for lunch.")
    end
  end

end
