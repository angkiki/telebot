class TelebotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def telebot_webhook
    # just to make sure that the request is coming in with the expected json key
    if params['message']
      # get hold of the important params first
      @chat_id = params['message']['chat']['id'] # chat id
      @users_telegram_id = params['message']['from']['id'] #users unique identifier for telegram
      @command = params['message']['text']
      @username = params['message']['from']['username']
      @chat_type = params['message']['chat']['type'] # if is group, you want to check for @angkiki_bot

      # query for the chat
      @chat = Chat.find_by(chat_id: @users_telegram_id)

      # not nil, chat_id exists
      if (@chat)
        # parse the incoming coming
        @parsed_command = parse_incoming_text(@command, @chat_type)

        # render text according to the incoming command
        if @parsed_command
          @text = "Hi #{@username}, you sent the command #{@parsed_command[0]}"
        else
          @text = "Hi #{@username}, you sent an invalid command"
        end

        # respond to user 
        @response = {
          "method": "sendMessage",
          "chat_id": @chat_id,
          "text": @text
        }
        render json: @response, status: 200
      else
        # first time user is talking to our bot
        Chat.new_chat(@users_telegram_id, @username)

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


  private
  # telebot helper methods

  # check if it is a command we recognise
  def accepted_commands(command)
    @COMMANDS = [
      '/food',
      '/shopping',
      '/transport',
      '/misc',
      '/save',
      '/cancel',
    ]

    return @COMMANDS.index(command)
  end

  # parsing the incoming text, chat type is for us to determine
  # if we want to check for @angkiki_bot
  def parse_incoming_text(text, chat_type)
    text.include?('@angkiki_bot') ? @command = text.split('@angkiki_bot') : @command = text.split(' ')
    @valid_command = accepted_commands(@command[0])

    if @valid_command
      return @valid_command == 4 ? [@command[0], @command[1], @command[2]] : [@command[0]]
    end

    false
  end
end
