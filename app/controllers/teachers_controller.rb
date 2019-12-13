require 'net/http'

class TeachersController < ApplicationController
    def create
        # Receive nested hash from field_for in the view
        if Teacher.exists?(email: teacher_params[:email])
            redirect_to root_path, alert: "User with this email already exists"
        else
            if School.exists?(name: school_params[:name], city: school_params[:city], state: school_params[:state])
                @school = School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state])
            else
                @school = School.new school_params
            end
            if !@school.save
                redirect_to root_path, alert: "Error submitting school information"
            else
                @teacher = @school.teachers.build teacher_params
                @teacher.validated = false
                if @teacher.save
                    flash[:saved_teacher] = true
                    TeacherMailer.form_submission(@teacher).deliver_now
                    redirect_to root_path
                else
                    redirect_to root_path, alert: "Error submitting teacher information"
                end
            end
        end
    end

    def validate
        id = params[:id]
        teacher = Teacher.find_by(:id => id)
        teacher.validated = true
        teacher.school.num_validated_teachers += 1
        teacher.school.save!
        teacher.save!
        TeacherMailer.welcome_email(teacher).deliver_now
        redirect_to root_path
    end

    def delete
        id = params[:id]
        Teacher.delete(id)
        redirect_to root_path
    end

    private
        # def prepare_school
        #     # Receive nested hash from field_for in the view
        #     @school = School.new school_params
        #     if !@school.save
        #         redirect_to root_path, alert: "Failed to submit information :("
        #     end
        # end

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school, :email, :course, :snap, :other)
        end

        def school_params
            params.require(:school).permit(:name, :city, :state, :website)
        end
end