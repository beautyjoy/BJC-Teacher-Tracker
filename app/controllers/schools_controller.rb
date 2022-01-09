class SchoolsController < ApplicationController
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
      params.require(:school).permit(:name, :city, :state, :website)
    end
end
