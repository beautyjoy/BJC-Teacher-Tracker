class WorkshopsController < ApplicationController

  # TODO: revise any method using `set_workshops` to use `MockWorkshop.all` instead. It's currently used for mocking data.
  before_action :set_workshops, only: [:show, :edit]

  def index
    set_workshops
  end

  def show
    @workshop = @workshops.find { |workshop| workshop.id == params[:id].to_i }
  end

  def new
  end

  def edit
    @workshop = @workshops.find { |workshop| workshop.id == params[:id].to_i }
  end

  def create
  end

  def update
  end

  def destroy
  end

  def set_workshops
    @workshops = [
      Workshop.new(
        id: 1,
        name: "Web Development Basics",
        city: "San Francisco",
        state: "CA",
        country: "USA",
        start_date: "2024-04-01",
        end_date: "2024-04-30",
        # grade_level: "University",
        registration_open: true
      ),
      Workshop.new(
        id: 2,
        name: "Advanced Pottery",
        city: "New York",
        state: "NY",
        country: "USA",
        start_date: "2024-05-15",
        end_date: "2024-06-15",
        grade_level: 1,
        registration_open: false
      ),
      Workshop.new(
        id: 3,
        name: "Digital Photography",
        city: "London",
        state: "",
        country: "UK",
        start_date: "2024-07-01",
        end_date: "2024-07-31",
        grade_level: 0,
        registration_open: true
      )
    ]
  end
end
