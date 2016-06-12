class Access::RegistrationsController < Devise::RegistrationsController
  skip_before_action :auth_user!
  layout 'auth'

end