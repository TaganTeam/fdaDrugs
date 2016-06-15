module API
  module Concern::Session
    extend ActiveSupport::Concern
    included do
      desc "Return login status."
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post '/login' do
        authenticate_user!
        success!(current_user.as_api_response(:default_token), status)
      end

      desc 'Return logout status.'
      params do
        optional :access_token, type: String, desc: 'Security token'
      end
      delete '/logout' do
        logout_user!
        {code: 200, status: 'success', message: 'You are logged out successfully'}
      end
    end
  end
end