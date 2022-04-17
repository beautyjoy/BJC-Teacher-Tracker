# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :sanitize_params, only: [:new, :create, :edit, :update]
  before_action :require_admin
  def create
    @school = School.new(school_params)
    if @school.save
      flash[:success] = "Created #{@school.name} successfully."
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
