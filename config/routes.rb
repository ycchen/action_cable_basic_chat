Rails.application.routes.draw do
  get 'visitors/chat'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :messages, only: [:create]
  get :chat, to: 'visitors#chat'
  root to: 'visitors#chat'
end
