class MainController < ApplicationController
  def index
    @admin = (session.key?("logged_in") and session[:logged_in] == true)

    if @admin 
      @teachers = Teacher.where(validated: 'f')
      @validated_teachers = Teacher.where(validated: 't').order(:created_at)
      @schools = School.validated.group(:name, :city, :state, :website).count
      @courses = Teacher.where(validated: 'f').group(:course).count
      school_coords = School.select(:lat, :lng)

      @items = []
      school_coords.each do |school|
        @items << {
          'long': school[:lng],
          'lat': school[:lat]
        }
      end
    else 
      @teacher = Teacher.new
    end
  end

  def logout 
    session[:logged_in] = false
    redirect_to root_url
  end
end
