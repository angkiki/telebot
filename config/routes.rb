Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'
  get '/show-user', to: 'home#show_user', as: 'show_user'
  post '/telebot-webhook', to: 'telebot#telebot_webhook'
end
