class TeachersController < ApplicationController
    def create
        @teacher = Teacher.new teacher_params
        puts @teacher
        if @teacher.save
            cookies[:saved_teacher] = true
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