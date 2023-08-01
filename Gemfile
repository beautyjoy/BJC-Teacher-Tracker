# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "6.1.7.4"

# Production app server
gem "puma", "~> 5"
gem "pg", "~> 1.5"

# Front-end Assets
gem "webpacker"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Login via 3rd party services.
gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2"
gem "omniauth-microsoft_graph"
gem "omniauth-discourse", github: "29th/omniauth-discourse"
gem "omniauth-clever", github: "ClassTagInc/omniauth-clever", branch: "allow-newer-omniauth-oauth2-versions"
gem "omniauth-yahoo-oauth2", github: "nevans/omniauth-yahoo-oauth2"

# for timezone information for windows users
gem "tzinfo-data"
# for managing API keys
gem "figaro"

# Error Tracking
gem "sentry-ruby"
gem "sentry-rails"

# Render email templates
gem "liquid"

# Store uploaded files
gem "aws-sdk-s3", require: false

# Render images for file uploads in pages
gem "image_processing", ">= 1.2"

gem "selectize-rails"
gem "smarter_csv", "~> 1.4"
gem "activerecord-import", require: false

gem "httparty", "~> 0.21.0"

group :development do
  gem "annotate"
  gem "guard"
  gem "guard-rspec", require: false
  gem "guard-cucumber"
  gem "guard-shell"

  # Intercept and view emails in a browser
  gem "letter_opener"
  gem "letter_opener_web", "~> 2"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"

  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
end

group :development, :test do
  gem "byebug"
  gem "pry"
  gem "pry-byebug", "~> 3.9"

  gem "spring"
end

group :linters, :development, :test do
  gem "pronto", require: false
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "haml-lint", require: false
  gem "pronto-flay", require: false
  gem "pronto-haml", require: false
  gem "pronto-rubocop", require: false
  gem "rubocop-faker", require: false
end

# setup Cucumber, RSpec, Guard support
group :test do
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "simplecov-json", require: false
  gem "simplecov-console", require: false
  gem "simplecov-csv", require: false
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "metric_fu"
  gem "selenium-webdriver"

  gem "webdrivers"
  # Accessibility Testing
  gem "axe-core-rspec"
  gem "axe-core-cucumber"

  gem "rails-controller-testing"
end
