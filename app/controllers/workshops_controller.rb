class WorkshopsController < ApplicationController
  def index
    # TODO: here is mocked data for workshops. Fix them after the model is created and the database is seeded.
    @workshops = [
      OpenStruct.new(
        id: 1,
        name: "Web Development Basics",
        location: "San Francisco",
        start_date: "2024-04-01",
        end_date: "2024-04-30",
        grade_level: "Beginner",
        registration_open: true
      ),
      OpenStruct.new(
        id: 2,
        name: "Advanced Pottery",
        location: "New York",
        start_date: "2024-05-15",
        end_date: "2024-06-15",
        grade_level: "Advanced",
        registration_open: false
      ),
      OpenStruct.new(
        id: 3,
        name: "Digital Photography",
        location: "London",
        start_date: "2024-07-01",
        end_date: "2024-07-31",
        grade_level: "Intermediate",
        registration_open: true
      )
    ]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
