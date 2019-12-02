class AdminsController < ApplicationController
  def new
    @administrator = Admin.new
  end

  def create
    @administrator = Admin.new(params[:admin])
    if @administrator.save
      flash[:notice] = "You signed up successfully"
    else
      flash[:notice] = "Form is invalid"
    end
    render "new"
  end

  def index
    render "main/admin"
  end

  def googleAuth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    adminastrator = Admin.from_omniauth(access_token)
    log_in(admin)
    # Access_token is used to authenticate request made from the rails application to the google server
    adminastrator.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    admin.google_refresh_token = refresh_token if refresh_token.present?
    adminastrator.save
    redirect_to root_path
  end
end