class AuthController < ApplicationController
  protect_from_forgery
  layout 'auth'
  skip_before_action :verify_authenticity_token
  skip_before_action :auth_user!

  def login
    @user = User.new
  end

  def registration
    @user = User.new
  end

  def redirect
    current_user ? (redirect_to '/#/' + params[:path]) : (redirect_to login_path)
  end
end
