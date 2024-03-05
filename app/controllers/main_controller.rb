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
      message = "Your application is #{mapped_application_status(current_user.application_status)}. You may update your information. Please check your email for more information."
      # flash[:warn] for yellow warning message in bootstrap style, flash[:alert] for red alert message
      flash_type = current_user.application_status == "info_needed" ? :warn : :alert
      redirect_to edit_teacher_path(current_user.id), flash_type => message
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

  private
  def mapped_application_status(status)
    case status
    when "info_needed"
      "requested to be updated"
    when "denied"
      "denied"
    else
      status
    end
  end
end
