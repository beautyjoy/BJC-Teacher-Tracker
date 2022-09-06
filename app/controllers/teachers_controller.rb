# frozen_string_literal: true

require "smarter_csv"
require "csv_process"
require "activerecord-import"

class TeachersController < ApplicationController
  include CsvProcess

  before_action :load_pages, only: [:new, :create, :edit, :update]
  before_action :sanitize_params, only: [:new, :create, :edit, :update]
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:validate, :deny, :delete, :index, :show]
  before_action :require_edit_permission, only: [:edit, :update, :resend_welcome_email]

  rescue_from ActiveRecord::RecordNotUnique, with: :deny_access

  # Pages which are publicly visible.
  layout "page_with_sidebar", only: [:new, :edit, :update]

  def index
    @all_teachers = Teacher.where(admin: false)
    @admins = Teacher.where(admin: true)
  end

  def show
    load_teacher
    @school = @teacher.school
    @status = is_admin? ? "Admin" : "Teacher"
  end

  def new
    ordered_schools
    @teacher = Teacher.new
    @teacher.school = School.new
    @school = @teacher.school # maybe delegate this
    @readonly = false
  end

  # TODO: This needs to be re-written.
  # If you are logged in and not an admin, this should fail.
  def create
    # Find by email, but allow updating other info.
    @teacher = Teacher.find_by(email: teacher_params[:email])
    if @teacher && defined?(current_user.id) && (current_user.id == @teacher.id)
      params[:id] = current_user.id
      update
      return
    end

    load_school
    if !@school
      @school = School.new(school_params)
      if !@school.save
        flash[:alert] = "An error occurred! #{@school.errors.full_messages}"
        render "new"
        return
      end
    end


    @teacher = Teacher.new(teacher_params)
    @teacher.school = @school
    if @teacher.save
      @teacher.pending!
      flash[:success] = "Thanks for signing up for BJC, #{@teacher.first_name}! You'll hear from us shortly. Your email address is: #{@teacher.email}."
      TeacherMailer.form_submission(@teacher).deliver_now
      redirect_to root_path
    else
      redirect_to new_teacher_path, alert: "An error occurred while trying to submit teacher information. #{@teacher.errors.full_messages}"
    end
  end

  def edit
    load_teacher
    ordered_schools
    @school = @teacher.school
    @status = is_admin? ? "Admin" : "Teacher"
    @readonly = !is_admin?
  end

  def update
    load_teacher
    ordered_schools
    @teacher.assign_attributes(teacher_params)
    if (@teacher.email_changed? || @teacher.snap_changed?) && !is_admin?
      redirect_to edit_teacher_path(current_user.id), alert: "Failed to update your information. If you want to change your email or Snap! username, please email contact@bjc.berkeley.edu."
      return
    end
    if !@teacher.validated? && !current_user.admin?
      TeacherMailer.form_submission(@teacher).deliver_now
    end
    @teacher.save!
    if is_admin?
      redirect_to teachers_path, notice: "Saved #{@teacher.full_name}"
      return
    end
    redirect_to edit_teacher_path(current_user.id), notice: "Successfully updated your information"
  end

  def validate
    # TODO: Check if teacher is already denied (MAYBE)
    # TODO: move to model and add tests
    load_teacher
    @teacher.validated!
    @teacher.school.num_validated_teachers += 1
    @teacher.school.save!
    TeacherMailer.welcome_email(@teacher).deliver_now
    redirect_to root_path
  end

  def deny
    # TODO: Check if teacher is already validated (MAYBE)
    load_teacher
    @teacher.denied!
    @teacher.school.num_denied_teachers += 1
    @teacher.school.save!
    if !params[:skip_email].present?
      TeacherMailer.deny_email(@teacher, params[:reason]).deliver_now
    end
    redirect_to root_path
  end

  def delete
    unless is_admin?
      redirect_to root_path, alert: "Only administrators can delete!"
    else
      Teacher.delete(params[:id])
      redirect_to root_path
    end
  end

  def resend_welcome_email
    load_teacher
    if @teacher.validated? || @is_admin
      TeacherMailer.welcome_email(@teacher).deliver_now
    end
  end

  def import
    csv_file = params[:file]
    teacher_hash_array = SmarterCSV.process(csv_file)
    csv_import_summary_hash = process_record(teacher_hash_array)
    add_flash_message(csv_import_summary_hash)
    redirect_to teachers_path
  end

  private
  def load_teacher
    @teacher ||= Teacher.find(params[:id])
  end

  def deny_access
    redirect_to new_teacher_path, alert: "Email address or Snap username already in use. Please use a different email or Snap username."
  end

  def load_school
    if params[:school_id]
      @school ||= School.find(params[:school_id])
    end
    @school ||= School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state])
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :status, :snap,
      :more_info, :personal_website, :education_level, :school_id)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website, :grade_level, :school_type)
  end

  def ordered_schools
    if params[:id]
      load_teacher
      @ordered_schools ||= [ @teacher.school ] +
        School.all.order(:name).reject { |s| s.id == @teacher.school_id }
    else
      @ordered_schools ||= School.all.order(:name)
    end
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

    if params[:school]
      if params[:school][:grade_level]
        params[:school][:grade_level] = params[:school][:grade_level].to_i
      end
      if params[:school][:school_type]
        params[:school][:school_type] = params[:school][:school_type].to_i
      end
    end
  end

  def load_pages
    @pages ||= Page.where(viewer_permissions: Page.viewable_pages(current_user))
  end
end
