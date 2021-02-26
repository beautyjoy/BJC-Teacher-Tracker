module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    session[:logged_in] = true
  end

  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      @current_user ||= Teacher.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil? && session[:logged_in]
  end
end
