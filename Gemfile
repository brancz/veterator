source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.1'
gem 'active_model_serializers'
gem 'devise'
gem 'cancan'
gem 'rack-cors', require: 'rack/cors'
gem 'grape'
gem 'pg'
gem 'rails_12factor', group: :production
gem 'puma'

# Frontend ...
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-bootstrap-material-design'
  gem 'rails-assets-d3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # load env vars from .env file
  gem 'dotenv-rails'

  # simple smtp server
  gem 'mailcatcher'

  # testing framework
  gem 'rspec-rails'
  gem 'rspec-activejob'
  gem 'rspec-collection_matchers'

  # db factories
  gem 'factory_girl_rails'

  # cleaning the database after test runs
  gem 'database_cleaner'

  # simulate heroku env
  gem 'foreman'
end

