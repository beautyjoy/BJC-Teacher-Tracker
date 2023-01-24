# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    # TODO: remove the :logged_in, replace user_id with user_remember_token
    session[:user_id] = user.id
    session[:logged_in] = true
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
