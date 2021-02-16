class ApplicationController < ActionController::Base
  before_action :set_raven_context

  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # TODO: This really need to be tweaked!
  def is_admin?
    @is_admin ||= session.key?("logged_in") and session[:logged_in] == true
  end

  def require_admin
    unless is_admin?
      flash[:danger] = 'Only admins can access this page.'
      redirect_to root_path
    end
  end

  private

  def set_raven_context
    return unless !Rails.env.development? and !Rails.env.test?
    Sentry.user_context(id: session[:user_id]) # or anything else in session
    Sentry.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
