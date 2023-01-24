# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    reset_session
    redirect_to root_url
  end

  def omniauth_callback
    omniauth_data = request.env["omniauth.auth"].info
    user = Teacher.user_from_omniauth(omniauth_data)
    if user.present?
      user.last_session_at = Time.zone.now
      user.save!
      log_in(user)
    else
      Sentry.capture_message("OAuth Login Failure")
      session[:auth_data] = omniauth_data
      flash[alert] = "We couldn't find an account for #{omninauth_data.email}. Please submit a new request."
    end
    redirect_to root_path
  end

  def omniauth_failure
    redirect_to root_url,
                alert: "Login failed unexpectedly. Please reach out to contact@bjc.berkeley.edu"
  end
end
