class MainController < ApplicationController
  def index
    @teacher = Teacher.new
  end

  def dashboard
    schools = School.select(:lat, :lng)

    @items = []
    schools.each do |school|
      @items << {
        'long': school[:lng],
        'lat': school[:lat]
      }
    end
  end
end