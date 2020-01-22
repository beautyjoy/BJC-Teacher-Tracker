class TeachersController < ApplicationController
  before_action :set_teacher_and_school
  before_action :require_admin, except: [:new, :create]

  def index
    @validated_teachers = Teacher.where(validated: true)
  end

  def new; end

  def create
    if Teacher.exists?(email: teacher_params[:email])
      flash[:alert] = "A user with this email already exists!"
      redirect_to new_teacher_path
    else
      @school = School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state]) || School.new(school_params)
      if !@school.save
        redirect_to new_teacher_path, alert: "An error occured! #{@school.errors.full_messages}"
      else
        @teacher = @school.teachers.build(teacher_params)
        @teacher.validated = false
        if @teacher.save
          flash[:success] =
            "Thanks for signing up for BJC, #{@teacher.first_name}! You'll hear from us shortly."
          TeacherMailer.form_submission(@teacher).deliver_now
          redirect_to root_path
        else
          redirect_to new_teacher_path, alert: "An error occurred while trying to submit teacher information. #{@teacher.errors.full_messages}"
        end
      end
    end
  end

  def validate
    if !is_admin?
      redirect_to root_path, alert: "Only administrators can validate!"
    else
      id = params[:id]
      teacher = Teacher.find_by(:id => id)
      teacher.validated = true
      teacher.school.num_validated_teachers += 1
      teacher.school.save!
      teacher.save!
      TeacherMailer.welcome_email(teacher).deliver_now
      redirect_to root_path
    end
  end

  def delete
    if !is_admin?
      redirect_to root_path, alert: "Only administrators can delete!"
    else
      Teacher.delete(params[:id])
      redirect_to root_path
    end
  end

  private

  def set_teacher_and_school
    @teacher = Teacher.new(new_object_params[:teacher])
    @school = School.new(new_object_params[:school])
  end

  def new_object_params
    params.permit(
      school: [:first_name, :last_name, :school, :email, :course, :snap, :other],
      teacher: [:name, :city, :state, :website]
    )
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :course, :snap, :other)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website)
  end
end
