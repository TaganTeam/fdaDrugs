module API::Helpers::AuthHelper
  def warden
    env['warden']
  end

  def authenticate_user!
    if !authenticated
      error_401!("Unauthorized access")
    elsif current_user.errors.present?
      error_401!(current_user.errors.full_messages.uniq)
    end
  end

  def logout_user!
    warden.logout
  end

  def current_user
    if params[:route_info] && params[:route_info].is_a?(Grape::Route) && params[:access_token].present?
      @current_user
    else
      # user = warden.user

      user = warden.user.nil? ? User.find_by_email(params[:email]) : warden.user
      user.validate_request!(request,params)
      user
    end
  end

  def authenticated
    # return false if !warden.authenticated? && !([params[:login], params[:password], params[:access_token]].all? &:nil?)
    #TODO check it for another frontend-clients later
    return false if !warden.authenticated? && ([params[:login], params[:password], params[:access_token]].all? &:nil?)
    if params[:access_token].present?
      @current_user = User.find_by(authentication_token: params[:access_token])
    else
      return true if warden.authenticated?
      @current_user = User.authenticate(params[:email], params[:password])
    end

    @current_user.validate_request!(request,params) if @current_user
    @current_user
  end

end
