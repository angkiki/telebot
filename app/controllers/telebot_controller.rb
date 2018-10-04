class TelebotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def telebot_webhook
    if params['message']
      @chat_id = params['message']['chat']['id']
      @command = params['message']['text']

      @response = {
        "method": "sendMessage",
        "chat_id": @chat_id,
        "text": "Hello! :)",
        "html": "<p>Ok</p>"
      }

      respond_to do |format|
        format.json { render json: @response, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render json: {error: 'Error', html: '<p>Error</p>'}, status: 422 }
      end
    end
  end

end
