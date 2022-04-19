# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :sanitize_params, only: [:new, :create, :edit, :update]
  before_action :require_admin
  def search
    School.all.collect { |school| ["#{school.name}, #{school.city}, #{school.state}", school.name] }
  end
  def create
    other_school = School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state])
    @school = School.new(school_params)
    if @school.equal(other_school) == false && @school.save
      flash[:success] = "Created #{@school.name} successfully."
      redirect_to schools_path
    elsif @school.equal(other_school) == true
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
      if params[:school] # Validate input for nces_id
        if params[:school][:nces_id] && (params[:school][:nces_id].to_i < 0 || 999999999999 < params[:school][:nces_id].to_i)
          raise ArgumentError.new("Invalid nces_id")
        end
      end

      params.require(:school).permit(:name, :city, :state, :website, :grade_level, :school_type, :tags, :nces_id)
    end

    def sanitize_params
      if params[:school]
        if params[:school][:grade_level]
          params[:school][:grade_level] = params[:school][:grade_level].to_i
        end
        if params[:school][:school_type]
          params[:school][:school_type] = params[:school][:school_type].to_i
        end
      end
    end
end
