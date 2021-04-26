Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
  provider :microsoft_graph, ENV['MICROSOFT_CLIENT_ID'], ENV['MICROSOFT_CLIENT_SECRET'], { :scope => ENV['MICROSOFT_SCOPES'] }
  provider :discourse, sso_url: ENV['SNAP_CLIENT_URL'], sso_secret: ENV['SNAP_CLIENT_SECRET']
  provider :clever, ENV['CLEVER_CLIENT_ID'], ENV['CLEVER_CLIENT_SECRET']
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:omniauth_failure).call(env)
end
