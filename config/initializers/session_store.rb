# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

session_options = { key: '_bjc_teacher_tracker_session' }

# Superconductor Live Preview embeds the development app on a different HTTPS
# origin, so development session cookies must be iframe-compatible there.
if Rails.env.development? && ENV['AGENT_WEB_HOST'].present?
  session_options.merge!(same_site: :none, secure: true)
end

Rails.application.config.session_store :cookie_store, **session_options
