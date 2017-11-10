class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message) #*args
    # Do something later
    ActionCable.server.broadcast "chat", {message: render_message(message)}
  end

  def render_message(message)
  	MessagesController.render(partial: 'message', locals: {message: message}).squish
  end
end
