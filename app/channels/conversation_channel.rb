class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations-#{current_academico.id}"
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last
    end

    Message.create(message_params)
  end

  #class Message < ApplicationRecord
   # belongs_to :academico
   # belongs_to :conversation

    #after_create_commit { MessageBroadcastJob.perform_later(self) }
  #end

end
