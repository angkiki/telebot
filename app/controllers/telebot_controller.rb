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
        @parsed_command = parse_incoming_text(@command)

        # render text according to the incoming command
        if @parsed_command
          @text = check_command_sequence(@chat.command, @parsed_command, @chat)
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
  def parse_incoming_text(text)
    text.include?('@angkiki_bot') ? @command = text.downcase.split('@angkiki_bot') : @command = text.downcase.split(' ', 2)
    @valid_command = accepted_commands(@command[0])

    if @valid_command
      if @valid_command == 4
        return @command[1] ? [ @command[0], @command[1].strip ] : [ @command[0] ]
      else
        return [ @command[0] ]
      end
    end
    false
  end

  # take in the incoming command, and existing command and check if its correct
  def check_command_sequence(current_command, incoming_command, chat)
    # incoming_command will always be [ COMMAND, ARGUMENTS ]
    # if current_command is /done, expect Initiators
    # if current_command is /done, and incoming_command is /cancel, say nothing to cancel
    # if current_command is Initiators, expect /save or /cancel
    case current_command
    when '/done'
      if (incoming_command[0] == '/cancel')
        # nothing to cancel
        return "Hi #{chat.username}, you have no ongoing commands with Fwenny, so I have nothing to cancel!"
      elsif (incoming_command[0] == '/save')
        # nothing to save
        return "Hi #{chat.username}, you have not initiated a new budget sequence. Please send Fwenny either /food, /shopping, /transport or /misc to start a new sequence."
      else
        # update Chat to indicate new sequence
        Chat.update_command(chat, incoming_command[0])
        # incoming_command == Initiators
        return "Hi #{chat.username}, you have initiated the #{incoming_command[0]} sequence. Please reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      end
    when '/food', '/shopping', '/transport', '/misc'
      if (incoming_command[0] == '/cancel')
        Chat.update_command(chat, '/done')
        return "Hi #{chat.username}, you have cancelled the current sequence - #{current_command}"
      elsif (incoming_command[0] == '/save')
        # check to make sure its not a blank /save command without [AMOUNT] & [DESCRIPTION]
        if (incoming_command[1])
          @amount = parse_to_float(incoming_command[1].split(' ', 2)[0])
          @description = incoming_command[1].split(' ', 2)[1]
          Transaction.create(amount: @amount, description: @description, chat: chat, category: current_command)
        end

        if @amount && @amount > 0.0 && @description
          return "Hi #{chat.username}, you are recording the following transaction: #{current_command} - $#{@amount} for: #{@description}."
        end

        "Hi #{chat.username}, you need to reply with /save@angkiki_bot [AMOUNT] [DESCRIPTION] to save your transaction"
      else
        return "Hi #{chat.username}, this feature is a work in progress!"
      end
    end # end of case
  end # end of check_command_sequence

  def parse_to_float(str)
    begin
      number = Float(str)
      return number
    rescue ArgumentError
      return false
    end
  end
end
