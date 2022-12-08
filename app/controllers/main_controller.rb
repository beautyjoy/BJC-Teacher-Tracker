# frozen_string_literal: true

class MainController < ApplicationController
  before_action :require_admin, only: [:dashboard]

  def index
    flash.keep
    if is_admin?
      redirect_to dashboard_path
    elsif is_teacher? && current_user.validated?
      flash[:notice] = "Welcome back, #{@current_user.first_name}!"
      redirect_to pages_path
    elsif is_teacher?
      flash[:notice] = "You can edit your information"
      flash[:warning] = "Your applicating is currently #{@current_user.application_status}."
      redirect_to edit_teacher_path(current_user.id)
    else
      redirect_to new_teacher_path
    end
  end

  def dashboard
    @unvalidated_teachers = Teacher.unvalidated.order(:created_at) || []
    @validated_teachers = Teacher.validated.order(:created_at) || []
    @statuses = Teacher.validated.group(:status).order(count_all: :desc).count
    @schools = School.validated.order(teachers_count: :desc).limit(20)
  end
end
