# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "rails", "~> 6"

# Production app server
gem "puma", "~> 5"
gem "pg", "~> 1.0"

# Front-end Assets
gem "webpacker", "~> 4"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Login via 3rd party services.
gem "omniauth", "~> 1.0"
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2"
gem "omniauth-microsoft_graph"
gem "omniauth-discourse"
gem "omniauth-clever"

# for timezone information for windows users
gem "tzinfo-data"
# for managing API keys
gem "figaro"

# Generate attr_accessors that transparently encrypt and decrypt attributes.
gem "attr_encrypted", "~> 3.1.0"

# Error Tracking
gem "sentry-ruby"
gem "sentry-rails"

# Render email templates
gem "liquid"

# Store uploaded files
gem "aws-sdk-s3", require: false

# Render images for file uploads in dynamic pages
gem "image_processing", ">= 1.2"

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
  gem "simplecov-cobertura", require: false
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
