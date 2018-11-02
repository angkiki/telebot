class HomeController < ApplicationController

  def home
  end

  def show_user
    @chat = Chat.find_by(chat_id: params[:chat_id])
    redirect_to root_path if !@chat
  end

end
