# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_sentry_user
  before_action :check_teacher_admin

  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_admin?
    @is_admin ||= logged_in? ? current_user.admin : false
  end

  def is_teacher?
    @is_teacher ||= logged_in? ? !current_user.admin : false
  end

  def is_verified_teacher?
    @is_verified_teacher ||= logged_in? ? !current_user.admin && current_user.display_application_status == "Validated" : false
  end

  def require_login
    unless logged_in?
      flash[:danger] = "You need to log in to access this."
      redirect_to root_path
    end
  end

  def require_admin
    unless is_admin?
      flash[:danger] = "Only admins can access this page."
      redirect_to root_path
    end
  end

  def require_edit_permission
    unless current_user.id == params[:id].to_i || is_admin?
      redirect_to edit_teacher_path(current_user.id), alert: "You can only edit your own information"
    end
  end

  private
    def check_teacher_admin
      is_admin?
      is_teacher?
    end

    def set_sentry_user
      Sentry.set_user(id: session[:user_id]) # or anything else in session
    end
end
