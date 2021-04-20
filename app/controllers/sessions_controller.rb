class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    # log_out if logged_in?
    session[:logged_in] = false
    session[:user_id] = nil
    redirect_to root_url
  end

  def omniauth_failure
    redirect_to root_url
  end

  def setTokens(service, token, refresh_token, user)
    case service
    when :google
      user.google_token = token
      user.google_refresh_token = refresh_token if refresh_token.present?
    when :microsoft
      user.microsoft_token = token
      user.microsoft_refresh_token = refresh_token if refresh_token.present?
    end
  end

  def generalAuth(service)
    # Get access tokens from the server
    access_token = request.env["omniauth.auth"]
    if Teacher.validate_access_token(access_token)
      # Tell them to register.
      user = Teacher.user_from_omniauth(access_token)
      # Access_token is used to authenticate request made from the Rails application to the server
      token = access_token.credentials.token
      # Refresh_token to request new access_token
      # Note: Refresh_token is only sent once during the first request
      refresh_token = access_token.credentials.refresh_token
      setTokens(service, token, refresh_token, user)
      user.save!
      log_in(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Please Submit a teacher request"
    end
  end

  def googleAuth
    # Manages the callback from Google
    generalAuth(:google)
  end

  def microsoftAuth
    # Manages the callback from Microsoft
    generalAuth(:microsoft)
  end
end
