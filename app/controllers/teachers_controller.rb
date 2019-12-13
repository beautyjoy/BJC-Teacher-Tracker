require 'net/http'

class TeachersController < ApplicationController
    before_action :login

    def login
        @admin = (session.key?("logged_in") and session[:logged_in] == true)
    end

    def site_parse(site)
        if site.includes? "https://"
            return site[8..-1]
        elsif site.includes? "http://"
            return site[7..-1]
        else
            return site
        end
    end

    def create
        if Teacher.exists?(email: teacher_params[:email])
            redirect_to root_path, alert: "User with this email already exists"
        else
            school_params[:website] = site_parse(school_params[:website])
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
        if !@admin
            redirect_to root_path, alert: "Only admins can validate"
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
            redirect_to root_path, alert: "Only admins can delete"
        else
            id = params[:id]
            Teacher.delete(id)
            redirect_to root_path
        end
    end

    def all
        if !@admin
            redirect_to root_path, alert: "Only admins can view all forms"
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