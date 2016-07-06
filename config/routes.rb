Rails.application.routes.draw do
  mount API::Base => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'application#show'

  def shared_devise_path
    {
        sign_up:  'register',
        sign_in:  'login',
        sign_out: 'logout'
    }
  end

  devise_for :users,
             path: 'access',
             path_names: shared_devise_path,
             controllers: {
                 sessions: 'access/sessions',
                 registrations: 'access/registrations',
                 passwords: 'access/passwords'
             }

  get '/login', to: 'auth#login'
  get '/registration', to: 'auth#registration'

  post '/deliver_email', to: 'email#deliver_email'

  get '/*path' => 'auth#redirect'
end
