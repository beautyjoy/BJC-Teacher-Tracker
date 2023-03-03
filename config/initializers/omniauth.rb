# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:email] if Rails.env.development?

  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], skip_jwt: true

  provider :microsoft_graph, ENV["MICROSOFT_CLIENT_ID"], ENV["MICROSOFT_CLIENT_SECRET"],
           { scope: "openid profile email" }

  provider :discourse, sso_url: ENV["SNAP_CLIENT_URL"], sso_secret: ENV["SNAP_CLIENT_SECRET"]

  provider :clever, ENV["CLEVER_CLIENT_ID"], ENV["CLEVER_CLIENT_SECRET"]

  provider :yahoo_OAuth2, ENV["YAHOO_CLIENT_ID"], ENV["YAHOO_CLIENT_SECRET"], name: "yahoo"
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:omniauth_failure).call(env)
  # Rails.logger.warn "Omniauth Failure: #{env}"
end
