class TeachersController < ApplicationController
  before_action :sanitize_params, only: [:new, :create, :edit, :update]
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:validate, :deny, :delete, :index]
  before_action :require_edit_permission, only: [:edit, :update]

  rescue_from ActiveRecord::RecordNotUnique, with: :deny_access

  def index
    @all_teachers = Teacher.where(admin: false)
  end

  def new
    @teacher = Teacher.new
    @school = School.new
    @readonly = false
  end

  def create
    # TODO: This needs to be re-written.
    @school = School.new(school_params)
    # Find by email, but allow updating other info.
    @teacher = Teacher.find_by(email: teacher_params[:email])
    if @teacher and defined?(current_user.id) and current_user.id == @teacher.id
      params[:id] = current_user.id
      update
      return
    end
    @school = school_from_params
    if !@school.save
      flash[:alert] = "An error occured! #{@school.errors.full_messages}"
      render 'new'
      return
    end
    @teacher = @school.teachers.build(teacher_params)
    @teacher.application_status = "Pending"
    if @teacher.save
      flash[:success] = "Thanks for signing up for BJC, #{@teacher.first_name}! You'll hear from us shortly. Your email address is: #{@teacher.email}."
      TeacherMailer.form_submission(@teacher).deliver_now
      TeacherMailer.teals_confirmation_email(@teacher).deliver_now
      redirect_to root_path
    else
      redirect_to new_teacher_path, alert: "An error occurred while trying to submit teacher information. #{@teacher.errors.full_messages}"
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    @status = is_admin? ? "Admin" : "Teacher"
    @readonly = !is_admin?
  end

  def update
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    old_email, old_snap = @teacher.email, @teacher.snap
    new_email, new_snap = teacher_params[:email], teacher_params[:snap]
    if ((old_email != new_email) || (old_snap != new_snap)) && !is_admin?
      redirect_to edit_teacher_path(current_user.id), alert: "Failed to update your information. If you want to change your email or Snap! username, please contact an admin."
      return
    end
    @teacher.assign_attributes(teacher_params)
    @school.assign_attributes(school_params)
    # Resends form email only when pending teacher updates
    TeacherMailer.form_submission(@teacher).deliver_now
    # Resends TEALS email only when said teacher changes status
    if @teacher.status_changed?
      TeacherMailer.teals_confirmation_email(@teacher).deliver_now
    end
    @teacher.save!
    @school.save!
    if is_admin?
      redirect_to teachers_path, notice: "Saved #{@teacher.full_name}"
      return
    end
    redirect_to edit_teacher_path(current_user.id), notice: "Successfully updated your information"
  end

  def validate
    # TODO: Check if teacher is already denied (MAYBE)
    # TODO: Clean this up so the counter doesn't need to be manually incremented.
    teacher = Teacher.find(params[:id])
    teacher.application_status = "Validated"
    teacher.school.num_validated_teachers += 1
    teacher.school.save!
    teacher.save!
    TeacherMailer.welcome_email(teacher).deliver_now
    redirect_to root_path
  end

  def deny
    # TODO: Check if teacher is already validated (MAYBE)
    # TODO: Clean this up so the counter doesn't need to be manually incremented.
    teacher = Teacher.find(params[:id])
    teacher.application_status = "Denied"
    teacher.school.num_denied_teachers += 1
    teacher.school.save!
    teacher.save!
    TeacherMailer.deny_email(teacher, params[:reason]).deliver_now
    redirect_to root_path
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

  def deny_access
    redirect_to new_teacher_path, alert: "Email address already in use. Please use a different email."
  end

  def school_from_params
    School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state]) || School.new(school_params)
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :status, :snap,
      :more_info, :personal_website, :education_level)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website)
  end

  def sanitize_params
    if params[:teacher]
      if params[:teacher][:status]
        params[:teacher][:status] = params[:teacher][:status].to_i
      end
      if params[:teacher][:education_level]
        params[:teacher][:education_level] = params[:teacher][:education_level].to_i
      end
    end
  end
end
