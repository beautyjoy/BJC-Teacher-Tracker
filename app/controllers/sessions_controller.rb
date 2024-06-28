# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    reset_session
    redirect_to root_url
  end

  def omniauth_callback
    user = Teacher.user_from_omniauth(omniauth_info)
    if user.present?
      user.last_session_at = Time.zone.now
      user.try_append_ip(request.remote_ip)
      user.session_count += 1
      user.save!
      log_in(user)
    else
      crumb = Sentry::Breadcrumb.new(
        category: "auth",
        data: { omniauth_env: omniauth_info },
        message: "No User Found failure",
        level: "info"
      )
      Sentry.add_breadcrumb(crumb)
      Sentry.capture_message("Omniauth No User Found")
      session[:auth_data] = omniauth_info
      flash[:alert] = "We couldn't find an account for #{omniauth_info.email}. Please submit a new request."
      redirect_to new_teacher_path
    end
  end

  def omniauth_info
    request.env["omniauth.auth"].info
  end

  def omniauth_failure
    crumb = Sentry::Breadcrumb.new(
      category: "auth",
      data: {
        omniauth_env: request.env["omniauth.auth"],
        omniauth_error: request.env["omniauth.error"],
        message: params[:message],
        strategy: params[:strategy]
      },
      message: "Authentication failure",
      level: "info"
    )
    Sentry.add_breadcrumb(crumb)
    Sentry.capture_message("Omniauth Failure")
    redirect_to root_url,
                alert: "Login failed unexpectedly. Please reach out to contact@bjc.berkeley.edu #{nyc_message} (#{params[:message]})"
  end

  private
  # Special warning for emails that end with @schools.nyc.gov
  def nyc_message
    return "" unless omniauth_info.email.downcase.ends_with?("@schools.nyc.gov")

    "Emails ending with @schools.nyc.gov are currently not working. Please try logging with Snap! or reach out to us to setup an alternate login method. Thanks!\n"
  end
end
