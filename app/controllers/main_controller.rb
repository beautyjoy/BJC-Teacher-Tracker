class MainController < ApplicationController
  def index
    @admin = (session.key?("logged_in") and session[:logged_in] == true)
    
    if @admin 
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
    else 
      puts "Oops!"
      @teacher = Teacher.new
    end
  end

  def logout 
    session[:logged_in] = false
    redirect_to root_url
  end
end
