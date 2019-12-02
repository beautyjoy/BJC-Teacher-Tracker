source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
#gem 'pg'
#gem "sqlite3", "~> 1.3.6"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
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



# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "sqlite3", "~> 1.3.6"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'jasmine-rails' # if you plan to use JavaScript/CoffeeScript
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber'
  gem 'guard-shell'
  
  # gem 'pg', '~> 0.15'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

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
  gem 'factory_girl_rails' # if using FactoryGirl
  gem 'metric_fu'        # collect code metrics
end

# make sure the following gems are in your production group:
group :production do
  gem 'pg', '~> 0.15'              # use PostgreSQL in production (Heroku)
  gem 'rails_12factor'  # Heroku-specific production settings
end
