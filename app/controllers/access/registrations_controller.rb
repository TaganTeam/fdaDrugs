class Access::RegistrationsController < Devise::RegistrationsController
  skip_before_action :auth_user!
  layout 'auth'
  skip_filter *_process_action_callbacks.map(&:filter)
  prepend_before_filter :allow_params_authentication!, only: :create
  prepend_before_filter only: [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }

end