class TeachersController < ApplicationController
  before_action :login

  def login
    @admin = (session.key?("logged_in") and session[:logged_in] == true)
  end

  def create
    if Teacher.exists?(email: teacher_params[:email])
      redirect_to root_path, alert: "A user with this email already exists!"
    else
      if School.exists?(name: school_params[:name], city: school_params[:city], state: school_params[:state])
        @school = School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state])
      else
        @school = School.new(school_params)
      end
      if !@school.save
        redirect_to root_path, alert: "An error occured! Please fill out the form fields correctly."
      else
        @teacher = @school.teachers.build(teacher_params)
        @teacher.validated = false
        if @teacher.save
          flash[:saved_teacher] = true
          TeacherMailer.form_submission(@teacher).deliver_now
          redirect_to root_path
        else
          redirect_to root_path, alert: "An error occurred while trying to submit teacher information!"
        end
      end
    end
  end

  def validate
    if !@admin
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
    if !@admin
      redirect_to root_path, alert: "Only administrators can delete!"
    else
      id = params[:id]
      Teacher.delete(id)
      redirect_to root_path
    end
  end

  def all
    if !@admin
      redirect_to root_path, alert: "Only administrators can view all forms!"
    else
      @validated_teachers = Teacher.where(validated: true)
    end
  end

  private

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :course, :snap, :other)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website)
  end
end
