module DeviseOverrides
  extend ActiveSupport::Concern

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email, :password, :remember_me])
  end

end