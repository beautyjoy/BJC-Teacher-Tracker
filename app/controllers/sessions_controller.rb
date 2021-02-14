class SessionsController < ApplicationController
  def new; end

  def create
    redirect_to "/auth/google_oauth2"
  end

  def destroy
    # log_out if logged_in?
    session[:logged_in] = false
    redirect_to root_url
  end

  def googleAuth
    # Manages the callback from Google
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]

    if Admin.validate_auth(access_token)
      # Tell them to register.
      admin = Admin.from_omniauth(access_token)
      log_in(admin)
      # Access_token is used to authenticate request made from the rails application to the google server
      admin.google_token = access_token.credentials.token
      # Refresh_token to request new access_token
      # Note: Refresh_token is only sent once during the first request
      refresh_token = access_token.credentials.refresh_token
      admin.google_refresh_token = refresh_token if refresh_token.present?
      admin.save
      session[:logged_in] = true
      redirect_to root_path
    else
      teacher = Teacher.from_omniauth(access_token)
      if teacher != nil
        log_in(teacher)
        # Access_token is used to authenticate request made from the rails application to the google server
        teacher.google_token = access_token.credentials.token
        # Refresh_token to request new access_token
        # Note: Refresh_token is only sent once during the first request
        refresh_token = access_token.credentials.refresh_token
        teacher.google_refresh_token = refresh_token if refresh_token.present?
        teacher.save
        session[:logged_in] = true
        redirect_to root_path
      else
        redirect_to root_path, alert: "Please submit a request."
      end
    end
  end
end
