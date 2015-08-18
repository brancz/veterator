source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails'
gem 'active_model_serializers'
gem 'devise'
gem 'cancancan'
gem 'rack-cors', require: 'rack/cors'
gem 'grape'
gem 'pg'
gem 'rails_12factor', group: :production
gem 'puma'
gem 'rails_admin'
gem 'lograge'

# Frontend ...
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-bootstrap-material-design'
  gem 'rails-assets-d3'
end

group :development, :test do
  # testing framework
  gem 'rspec-rails'
  gem 'rspec-activejob'
  gem 'rspec-collection_matchers'

  # feature testing
  gem 'capybara'

  # db factories
  gem 'factory_girl_rails'

  # cleaning the database after test runs
  gem 'database_cleaner'

  # let's track line coverage!
  gem 'codeclimate-test-reporter'
end

