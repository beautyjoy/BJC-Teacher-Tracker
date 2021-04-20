class SessionsController < ApplicationController
  def new; end

  def create
    redirect_to "/auth/microsoft_graph"
    #redirect_to "/auth/google_oauth2"
  end

  def destroy
    # log_out if logged_in?
    session[:logged_in] = false
    session[:user_id] = nil
    redirect_to root_url
  end

  def googleAuth
    # Manages the callback from Google
    # Get access tokens from the Google server
    access_token = request.env["omniauth.auth"]
    if Teacher.validate_access_token(access_token)
      # Tell them to register.
      user = Teacher.user_from_omniauth(access_token)
      # Access_token is used to authenticate request made from the rails application to the Google server
      user.google_token = access_token.credentials.token
      # Refresh_token to request new access_token
      # Note: Refresh_token is only sent once during the first request
      refresh_token = access_token.credentials.refresh_token
      user.google_refresh_token = refresh_token if refresh_token.present?
      user.save!
      log_in(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Please Submit a teacher request"
    end
  end

  def microsoftAuth
    # Manages the callback from Microsoft
    # Get access tokens from the Microsoft server
    access_token = request.env["omniauth.auth"]
    if Teacher.validate_access_token(access_token)
      # Tell them to register.
      user = Teacher.user_from_omniauth(access_token)
      # Access_token is used to authenticate request made from the rails application to the Microsoft server
      user.microsoft_token = access_token.credentials.token
      # Refresh_token to request new access_token
      # Note: Refresh_token is only sent once during the first request
      refresh_token = access_token.credentials.refresh_token
      user.microsoft_refresh_token = refresh_token if refresh_token.present?
      user.save!
      log_in(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Please Submit a teacher request"
    end
  end
end
