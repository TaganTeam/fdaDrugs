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
end


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

# XML/JSON API responses
gem 'acts_as_api', '~> 0.4.2'