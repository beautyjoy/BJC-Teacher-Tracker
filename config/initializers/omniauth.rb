Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
  provider :microsoft_graph, ENV['AZURE_APPLICATION_CLIENT_ID'], ENV['AZURE_APPLICATION_CLIENT_SECRET'], {
    :scope => ENV['AZURE_APPLICATION_SCOPES']
  }
end
