source 'https://rubygems.org'

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.4.3'

# Production app server
gem 'puma', '>= 4.3.5'

gem 'pg', '~> 1.0'

# Front-end Assets
gem 'webpacker'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# for google oauth
gem 'omniauth-google-oauth2'
# for timezone information for windows users
gem 'tzinfo-data'
# for managing API keys
gem 'figaro'

# Generate attr_accessors that transparently encrypt and decrypt attributes.
gem 'attr_encrypted', '~> 3.1.0'

gem 'sentry-raven'

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
end
