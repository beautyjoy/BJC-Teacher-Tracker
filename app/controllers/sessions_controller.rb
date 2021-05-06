class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    # log_out if logged_in?
    session[:logged_in] = false
    session[:user_id] = nil
    redirect_to root_url
  end

  def omniauth_callback
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
      setTokens(token, refresh_token, user)
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

  private

  def setTokens(token, refresh_token, user)
    case params[:provider]
    when "google_oauth2"
      user.google_token = token
      user.google_refresh_token = refresh_token || user.google_refresh_token
    when "microsoft_graph"
      user.microsoft_token = token
      user.microsoft_refresh_token = refresh_token || user.microsoft_refresh_token
    when "discourse"
      user.snap_token = token
      user.snap_refresh_token = refresh_token || user.snap_refresh_token
    when "clever"
      user.clever_token = token
      user.clever_refresh_token = refresh_token || user.clever_refresh_token
    end
  end
end
