# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :require_admin

  def index
    @schools = School.all.order(:name)
  end

  def show
    @school = School.find(params[:id])
  end

  def search
    School.all.collect { |school| ["#{school.name}, #{school.country}, #{school.city}, #{school.state}", school.name] }
  end

  def create
    @school = School.find_by(name: school_params[:name], country: school_params[:country], city: school_params[:city], state: school_params[:state])
    if @school
      @school.assign_attributes(school_params)
    else
      @school = School.new(school_params)
    end
    load_ordered_schools
    if @school.save
      flash[:success] = "Created #{@school.name} successfully."
      redirect_to schools_path
    else
      flash[:alert] = "Failed to submit information :("
      render "new"
    end
  end

  def new
    @school = School.new
    load_ordered_schools
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    @school.assign_attributes(school_params)
    if @school.save
      flash[:success] = "Update #{@school.name} successfully."
      redirect_to school_path(@school)
    else
      render "edit", alert: "Failed to submit information :("
    end
  end

  def destroy
    @school = School.find(params[:id])
    if @school.teachers_count > 0
      redirect_to schools_path(@school), alert: "Cannot delete a school which still has teachers"
      return
    end
    @school.destroy
    redirect_to schools_path, notice: "Deleted \"#{@school.name}\" successfully."
  end

  private
  def school_params
    params.require(:school).permit(:name, :country, :city, :state, :website, :grade_level, :school_type, :country, { tags: [] }, :nces_id)
  end

  def load_ordered_schools
    @ordered_schools ||= School.all.order(:name)
  end
end
