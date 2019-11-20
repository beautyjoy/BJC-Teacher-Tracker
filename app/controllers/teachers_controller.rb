class TeachersController < ApplicationController
    def create
        @teacher = Teacher.new teacher_params
        puts @teacher
        if @teacher.save
            flash[:saved_teacher] = true
            TeacherMailer.welcome_email(@teacher).deliver_now
            redirect_to root_path
        else
            redirect_to root_path, alert: "Failed to submit information :("
        end

    end

    private

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap)
        end
end