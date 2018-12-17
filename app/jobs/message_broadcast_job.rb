class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sender = message.academico
    recipient = message.conversation.opposed_user(sender)

    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(academico, message)
    ActionCable.server.broadcast(
        "conversations-#{academico.id}",
        message: render_message(message, academico),
        conversation_id: message.conversation_id
    )
  end

  def broadcast_to_recipient(academico, message)
    ActionCable.server.broadcast(
        "conversations-#{academico.id}",
        window: render_window(message.conversation, academico),
        message: render_message(message, academico),
        conversation_id: message.conversation_id
    )
  end

  def render_message(message, academico)
    ApplicationController.render(
        partial: 'messages/message',
        locals: { message: message, academico: academico }
    )
  end

  def render_window(conversation, academico)
    ApplicationController.render(
        partial: 'conversations/conversation',
        locals: { conversation: conversation, academico: academico }
    )
  end
end
