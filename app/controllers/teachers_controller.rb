class TeachersController < ApplicationController
  before_action :sanitize_params, only: [:new, :create]
  before_action :require_admin, except: [:new, :create]

  def index
    @validated_teachers = Teacher.where(validated: true)
  end

  def new
    @teacher = Teacher.new
    @school = School.new
  end

  def create
    set_teacher_and_school
    if Teacher.exists?(email: teacher_params[:email])
      flash[:alert] = "A user with this email already exists!"
      render 'new'
    else
      @school = school_from_params
      if !@school.save
        flash[:alert] = "An error occured! #{@school.errors.full_messages}"
        render 'new'
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
      teacher = Teacher.find(params[:id])
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

  def school_from_params
    School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state]) || School.new(school_params)
  end

  def set_teacher_and_school
    @teacher = Teacher.new(teacher_params)
    @school = School.new(school_params)
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :status, :snap, :more_info)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website)
  end

  def sanitize_params
    if params[:teacher] && params[:teacher][:status]
      params[:teacher][:status] = params[:teacher][:status].to_i
    end
  end
end
