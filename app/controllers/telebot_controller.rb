class TelebotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def telebot_webhook
    if params['message']
      @chat_id = params['message']['chat']['id']
      @command = params['message']['text']

      @response = {
        "method": "sendMessage",
        "chat_id": @chat_id,
        "text": "Hello! :)"
      }
      
      render json: @response, status: 200
    else
      render json: {error: 'Error'}, status: 422
    end
  end

end
