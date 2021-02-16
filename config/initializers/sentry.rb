Sentry.init do |config|
  config.enabled_environments = %w|production staging|

  config.dsn = ENV['SENTRY_DSN']
end
