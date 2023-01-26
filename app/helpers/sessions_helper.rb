# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    # TODO: remove the :logged_in, replace user_id with user_remember_token
    session[:user_id] = user.id
    session[:logged_in] = true
    if session[:redirect_on_login].present?
      redirect_to session[:redirect_on_login], success: "Welcome back, #{user.first_name}!"
      session[:redirect_on_login] = nil
    else
      redirect_to root_path
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= Teacher.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil? && session[:logged_in]
  end
end
