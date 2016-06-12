module API
  module Concern::Registration
    extend ActiveSupport::Concern
    included do
      resource :register do
        desc 'Register new user and return object user'
        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end
        post do
          user_hash = params[:user]
          user_hash = params.slice(:email, :password, :username) unless user_hash
          user_hash[:password_confirmation] = user_hash[:password] if user_hash[:password_confirmation].blank?

          params[:user] = user_hash
          permitted_params = permit_params(:user, Permits.controller(User.name))

          user = User.create(permitted_params)
          after_save(user, status, 'Your account is registered successfully', :default_token)
        end
      end

    end
  end
end