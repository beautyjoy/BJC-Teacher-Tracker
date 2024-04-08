# frozen_string_literal: true

require "factory_bot"

# This mocks omniauth for a given user.
def log_in(user, provider: "google_oauth2")
  OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
    provider: provider.to_s,
    uid: "123456789",
    info: {
      name: user.full_name,
      email: user.primary_email
    }
  })

  get omniauth_callback_path(provider:)
end
