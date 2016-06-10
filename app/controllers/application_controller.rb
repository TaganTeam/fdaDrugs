class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :auth_user!

  include DeviseOverrides

  def show
  end

  private

  def auth_user!
    exclusion_redirect = [login_path, registration_path].include?(request.fullpath)
    if current_user
      current_user.validate_request!(request,params)
      current_user_valid = !current_user.errors.present?
      if exclusion_redirect
        redirect_to root_path if current_user_valid
      else
        warden.logout unless current_user_valid
      end
    else
      redirect_to login_path if !exclusion_redirect
    end
  end
end
