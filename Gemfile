source 'https://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'vcr'
  gem 'webmock'
end


group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-bower',   require: false
  gem 'capistrano3-delayed-job', '~> 1.0'
end

gem 'puma'

gem 'angular-rails-templates'


# Haml as the templating engine for Rails
gem 'haml-rails', '~> 0.9'

# APPLICATION PROGRAMMING INTERFACE (API)
gem 'grape', '~> 0.9.0'
gem 'grape-swagger', '~> 0.8.0'
gem 'grape-swagger-rails', git: 'https://github.com/ruby-grape/grape-swagger-rails'
gem 'rack-cors', require: 'rack/cors'

# Flexible authentication solution for Rails with Warden
gem 'devise'
# Extracted Token Authenticatable module of devise
gem 'devise-token_authenticatable'

#A Scope & Engine based paginator
gem 'kaminari'

# XML/JSON API responses
gem 'acts_as_api', '~> 0.4.2'

# Parse web and xlx
gem 'wombat', '~> 2.5', '>= 2.5.1'
gem 'roo', '~> 2.4.0'
gem 'roo-xls'

gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'

gem 'newrelic_rpm'

gem 'activeadmin', github: 'activeadmin'

# Audited is an ORM extension that logs all changes to your models.
gem 'audited-activerecord', '~> 4.0'

# Calling destroy on an ActiveRecord object doesn't actually destroy the database record
gem 'paranoia', '~> 2.0'

gem 'sendgrid'
gem 'rails_db'
# gem 'axlsx_rails'

