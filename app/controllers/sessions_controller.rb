# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    reset_session
    redirect_to root_url
  end

  def omniauth_callback
    auth_info = request.env["omniauth.auth"]
    if Teacher.validate_access_token(auth_info)
      user = Teacher.user_from_omniauth(auth_info)
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
