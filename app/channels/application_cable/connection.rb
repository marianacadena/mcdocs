module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_academico

    def connect
      self.current_academico = find_verified_user
    end

    protected

    def find_verified_user
      if (current_academico = env['warden'].user)
        current_academico
      else
        reject_unauthorized_connection
      end
    end

  end
end
