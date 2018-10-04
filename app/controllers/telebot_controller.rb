class TelebotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def telebot_webhook
    # just to make sure that the request is coming in with the expected json key
    if params['message']
      # get hold of the important params first
      @chat_id = params['message']['from']['id'] #chat_id is the users unique identifier for telegram
      @command = params['message']['text']
      @username = params['message']['from']['username']

      # query for the chat
      @chat = Chat.find_by(chat_id: @chat_id)

      # not nil, chat_id exists
      if (@chat)
        @response = {
          "method": "sendMessage",
          "chat_id": @chat_id,
          "text": "Welcome back #{@username}! :D"
        }
        render json: @response, status: 200
      else
        # first time user is talking to our bot
        Chat.new_chat(@chat_id)

        # respond with first time greeting
        @response = {
          "method": "sendMessage",
          "chat_id": @chat_id,
          "text": "Hello! I see that you're new here. Welcome to Angkiki's Telebot :)"
        }
        render json: @response, status: 200
      end

    else
      render json: {error: 'Error'}, status: 422
    end
  end

end
