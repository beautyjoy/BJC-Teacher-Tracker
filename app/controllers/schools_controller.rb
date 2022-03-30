# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :require_admin
  def create
    byebug
    other_school = School.find_by(name: school_params[:name],city: school_params[:city],state: school_params[:state])
    @school = School.new(school_params)
    if @school.equal(other_school)== false && @school.save
      flash[:success] = "Created #{@school.name} successfully."
      redirect_to schools_path
    elsif@school.equal(other_school)== true
      redirect_to schools_path
    else
      redirect_to root_path, alert: "Failed to submit information :("
    end
  end

  def new
    @school = School.new
  end

  def index
    @schools = School.all
  end

  private
    def school_params
      params.require(:school).permit(:name, :city, :state, :website)
    end
end
