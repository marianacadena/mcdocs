class ChatController < ApplicationController
  before_action :authenticate_academico!
  def index
    session[:conversations] ||= []

    @academicos_conversation = Academico.all.where.not(id: current_academico)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])

  end
end
