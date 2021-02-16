Sentry.init do |config|
  # config.enabled_environments = %w|production staging development|

  config.dsn = ENV['SENTRY_DSN']
end
