class SchoolsController < ApplicationController
  def create
    @school= School.new school_params
    if @school.save
      flash[:saved_school] = true
    else
      redirect_to root_path, alert: "Failed to submit information :("
    end
  end

  def statistics
    @schools = School.validated
  end

  private

    def school_params
      params.require(:teacher).permit(:name, :city, :state, :website)
    end
end