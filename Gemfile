source 'https://rubygems.org'

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.4.5'

# Production app server
gem 'puma', '~> 5'

gem 'pg', '~> 1.0'

# Front-end Assets
gem 'webpacker', '~> 4'

# Login via 3rd party services.
gem 'omniauth', '~> 2.0'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-google-oauth2'

# for timezone information for windows users
gem 'tzinfo-data'
# for managing API keys
gem 'figaro'

# Generate attr_accessors that transparently encrypt and decrypt attributes.
gem 'attr_encrypted', '~> 3.1.0'

# Error Tracking
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'jasmine-rails' # if you plan to use JavaScript/CoffeeScript
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber'
  gem 'guard-shell'

  # Intercept and view emails in a browser
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# setup Cucumber, RSpec, Guard support
group :test do
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels' # basic imperative step defs
  gem 'database_cleaner' # required by Cucumber
  gem 'factory_bot_rails' # if using FactoryBot
  gem 'metric_fu'        # collect code metrics
  gem 'selenium-webdriver'
end
