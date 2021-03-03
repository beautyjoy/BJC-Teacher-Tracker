class MainController < ApplicationController
  before_action :require_admin, only: [:dashboard]
  before_action :check_teacher_admin
  def index
    if is_admin?
      redirect_to dashboard_path
    elsif is_teacher?
      redirect_to edit_teacher_path(current_user.id), notice: "You can edit your information"
    else
      redirect_to new_teacher_path
    end
  end

  def dashboard
    @unvalidated_teachers = Teacher.unvalidated.order(:created_at) || []
    @validated_teachers = Teacher.validated.order(:created_at) || []
    @statuses = Teacher.validated.group(:status).count
    @schools = School.validated.order(num_validated_teachers: :desc)
  end

  def logout
    session[:logged_in] = false
    session[:user_id] = nil
    redirect_to root_url
  end
end
