class MainController < ApplicationController
  before_action :require_admin, only: [:dashboard]

  def index
    if is_admin?
      redirect_to dashboard_path
    else
      redirect_to new_teacher_path
    end
  end

  def dashboard
    @unvalidated_teachers = Teacher.where(validated: 'f').order(:created_at) || []
    @validated_teachers = Teacher.where(validated: 't').order(:created_at) || []
    @schools = School.validated || []
    @courses = Teacher.where(validated: 't').group(:course).count
    school_coords = @schools.select(:lat, :lng)

    @items = []
    school_coords.each do |school|
      @items << {
        'long': school[:lng],
        'lat': school[:lat]
      }
    end
  end

  def logout
    session[:logged_in] = false
    redirect_to root_url
  end
end
