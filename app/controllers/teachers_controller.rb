class TeachersController < ApplicationController
    def create
        @teacher = Teacher.new teacher_params
        @teacher.validated = false
        if @teacher.save
            flash[:saved_teacher] = true
            #TeacherMailer.welcome_email(@teacher).deliver_now
            redirect_to root_path
        else
            redirect_to root_path, alert: "Failed to submit information :("
        end

    end

    def forms
        @teachers = Teacher.unvalidated
    end

    def validate
        id = params[:id]
        teacher = Teacher.find_by(:id => id)
        teacher.validated = true
        teacher.save!
        redirect_to forms_path
    end

    def delete
        id = params[:id]
        Teacher.delete(id)
        redirect_to forms_pat
    end

    private

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap, :other)
        end
end