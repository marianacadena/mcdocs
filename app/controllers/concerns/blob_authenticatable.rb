module BlobAuthenticatable
  extend ActiveSupport::Concern

  included do
    around_action :wrap_in_authentication
  end

  module ClassMethods
    def auth_resource
      @auth_resource || Devise.default_scope
    end

    private

    def blob_authenticatable(resource:)
      @auth_resource = resource
    end
  end

  private

  def wrap_in_authentication
    is_signed_in_and_authorized = send("#{self.class.auth_resource}_signed_in?") \
        & can_access_blob?(send("current_#{self.class.auth_resource}"))

    if is_signed_in_and_authorized
      yield
    else
      head :unauthorized
    end
  end

  def can_access_blob?(_user)
    true
  end
end
