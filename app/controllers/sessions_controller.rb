# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    reset_session
    redirect_to root_url
  end

  def omniauth_callback
    access_token = request.env["omniauth.auth"]
    if Teacher.validate_access_token(access_token)
      user = Teacher.user_from_omniauth(access_token)
      user.last_session_at = Time.zone.now
      user.save!
      log_in(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Please Submit a teacher request"
    end
  end

  def omniauth_failure
    redirect_to root_url, alert: "Login failed"
  end
end
