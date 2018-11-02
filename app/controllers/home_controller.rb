class HomeController < ApplicationController

  def home
  end

  def show_user
    @chat = Chat.find_by(chat_id: params[:chat_id])
    redirect_to root_path if !@chat

    @start_date = DateTime.new(params[:date][:year].to_i, params[:date][:month].to_i)
    @end_date = @start_date.end_of_month
    @transactions = @chat.transactions.where(created_at: @start_date..@end_date)
  end

end
