class TeachersController < ApplicationController
    before_action :prepare_school

    def create
        @teacher = @school.teachers.build teacher_params
        if @teacher.save
            flash[:saved_teacher] = true
            TeacherMailer.welcome_email(@teacher).deliver_now
            redirect_to root_path
        else
            redirect_to root_path, alert: "Failed to submit information :("
        end
    end

    private

        def prepare_school
            # Receive nested hash from field_for in the view
            @school = School.new school_params
            if !@school.save
                redirect_to root_path, alert: "Failed to submit information :("
            end
        end

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school, :email, :course, :snap, :other)
        end

        def school_params
            params.require(:school).permit(:name, :city, :state, :website)
        end
end