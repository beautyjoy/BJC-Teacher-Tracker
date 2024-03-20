# frozen_string_literal: true

class ProfessionalDevelopmentsController < ApplicationController
  # TODO: revise any method using `set_pds` to use `MockProfessionalDevelopments.all` instead. It's currently used for mocking data.
  before_action :set_pds, only: [:show, :edit, :update, :destroy]

  def index
    set_pds
  end

  def show
    @professional_development = @professional_developments.find { |pd| pd.id == params[:id].to_i }
  end

  def new
    @professional_development = ProfessionalDevelopment.new
    load_ordered_pds
  end

  def edit
    @professional_development = @professional_developments.find { |pd| pd.id == params[:id].to_i }
  end

  def create
    flash[:danger] = "This feature is not yet implemented."
    redirect_to new_professional_development_path
  end

  def update
    flash[:danger] = "This feature is not yet implemented."
    redirect_to edit_professional_development_path
  end

  def destroy
    flash[:danger] = "This feature is not yet implemented."
    redirect_to professional_developments_path
  end

  def set_pds
    @professional_developments = [
      ProfessionalDevelopment.new(
        id: 1,
        name: "Web Development Basics",
        city: "San Francisco",
        state: "CA",
        country: "USA",
        start_date: "2024-04-01",
        end_date: "2024-04-30",
        registration_open: true,
        pd_registrations: [
          PdRegistration.new(id: 1, teacher_id: 1, pd_id: 1, attended: true, role: "leader", teacher_name: "Alex Johnson"),
          PdRegistration.new(id: 2, teacher_id: 2, pd_id: 1, attended: false, role: "attendee", teacher_name: "Jamie Smith")
        ]
      ),
      ProfessionalDevelopment.new(
        id: 2,
        name: "Advanced Pottery",
        city: "New York",
        state: "NY",
        country: "USA",
        start_date: "2024-05-15",
        end_date: "2024-06-15",
        grade_level: "High School",
        registration_open: false,
        pd_registrations: [
          PdRegistration.new(id: 3, teacher_id: 3, pd_id: 2, attended: true, role: "attendee", teacher_name: "Sam Lee"),
          PdRegistration.new(id: 4, teacher_id: 4, pd_id: 2, attended: true, role: "leader", teacher_name: "Chris Doe")
        ]
      ),
      ProfessionalDevelopment.new(
        id: 3,
        name: "Digital Photography",
        city: "London",
        state: "",
        country: "UK",
        start_date: "2024-07-01",
        end_date: "2024-07-31",
        grade_level: "College",
        registration_open: true,
        pd_registrations: [
          PdRegistration.new(id: 5, teacher_id: 5, pd_id: 3, attended: false, role: "attendee", teacher_name: "Morgan Bailey"),
          PdRegistration.new(id: 6, teacher_id: 6, pd_id: 3, attended: true, role: "leader", teacher_name: "Casey Jordan"),
          PdRegistration.new(id: 7, teacher_id: 7, pd_id: 3, attended: true, role: "attendee", teacher_name: "Jordan Casey") # Added an extra registration for variety
        ]
      )
    ]
  end

  def load_ordered_pds
  #   not yet implemented
  end
end
