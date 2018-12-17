class RegistrationsController<Devise::RegistrationsController
  private
  def sign_up_params
    params.require(:academico).permit(:nombre, :apellidos, :email, :numPersonal, :password, :password_confirmation, :img_perfil)
  end

  def account_update_params
    params.require(:academico).permit(:nombre, :apellidos, :email, :numPersonal, :password, :password_confirmation, :current_password, :img_perfil)
  end
end