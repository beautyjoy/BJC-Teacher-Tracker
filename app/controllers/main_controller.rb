# frozen_string_literal: true

class MainController < ApplicationController
  before_action :require_admin, only: [:dashboard]

  def index
    flash.keep
    if is_admin?
      redirect_to dashboard_path
    # if this teacher is validated, redirect to pages
    elsif is_teacher? && current_user.validated?
      redirect_to pages_path, success: "Welcome back, #{current_user.first_name}!"
    # if this teacher is not validated (not_reviewed or info_needed), redirect to edit
    elsif is_teacher? && !current_user.validated?
      message = "Your application is currently #{current_user.application_status}. You may update your information."
      if current_user.application_status == "info_needed"
        # flash[:warn] for a yellow informational message
        redirect_to edit_teacher_path(current_user.id), warn: message
      else
        # flash[:alert] for a red warning message
        redirect_to edit_teacher_path(current_user.id), alert: message
      end
    # if this user is denied, redirect to new
    else
      redirect_to new_teacher_path
    end
  end

  def dashboard
    @unvalidated_teachers = Teacher.unvalidated.order(:created_at) || []
    @unreviewed_teachers = Teacher.unreviewed.order(:created_at) || []
    @validated_teachers = Teacher.validated.order(:created_at) || []
    @statuses = Teacher.validated.group(:status).order(count_all: :desc).count
    @schools = School.validated.order(teachers_count: :desc).limit(20)
  end
end
