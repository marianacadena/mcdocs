module WelcomeHelper
  def resource_name
    :academico
  end

  def resource
    @resource ||= Academico.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:academico]
  end
end
