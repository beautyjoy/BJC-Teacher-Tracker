class SessionsController < ApplicationController
  def create
    redirect_to "/auth/google_oauth2"
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def googleAuth
    # Manages the callback from Google
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    # TODO: don't register if the name in the token is not in the database.
    # Tell them to register.
    admin = Admin.from_omniauth(access_token)
    log_in admin
    # Access_token is used to authenticate request made from the rails application to the google server
    admin.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    admin.google_refresh_token = refresh_token if refresh_token.present?
    admin.save
    redirect_to root_path
  end
end
