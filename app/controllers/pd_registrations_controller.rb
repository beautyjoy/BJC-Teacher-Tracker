# frozen_string_literal: true

# Not sure how the ids are going to work with professional development.
# With a belongs to relationship, depending on the implementation,
# might have 2 ids in params that we need to distinguish between.
class PdRegistrationsController < ApplicationController
  before_action :require_login

  def index
    set_pds
  end

  def show
    @pd_registration = PdRegistration.find(params[:id])
  end

  def new
    @pd_registration = PdRegistration.new
  end

  def edit
    @pd_registration = PdRegistration.find(params[:id])
  end

  # Create and update do NOT support admin overriding user functionality yet, only normal user functionality
  def create
    @professional_development = pd_name_to_pd()
    if (!@professional_development)
      flash.now[:alert] = "Failed to save registration: No PD with that name exists.}"
      render :new
    end
    @pd_registration = PdRegistration.new(pd_registration_params)
    @pd_registration.professional_development = @professional_development
    @pd_registration.teacher = current_user
    if !@pd_registration.save
      flash.now[:alert] = "Failed to save registration: #{@pd_registration.errors.full_messages.join(", ")}"
      render :new
    end
    redirect_to pd_registrations_path, success: "PD registration created successfully."
  end

  def update
    @professional_development = pd_name_to_pd()
    if (!@professional_development)
      flash.now[:alert] = "Failed to save registration: No PD with that name exists.}"
      render :new
    end
    @pd_registration = PdRegistration.find(params[:id])
    @pd_registration.professional_development = @professional_development
    @pd_registration.teacher = current_user
    if !@pd_registration.update(pd_registration_params)
      flash.now[:alert] = "Failed to save registration: #{@pd_registration.errors.full_messages.join(", ")}"
      render "edit"
    end
    redirect_to pd_registrations_path, success: "Saved the PD registration."
  end

  def destroy
    if !@pd_registration.destroy
      redirect_back(fallback_location: pd_registrations_path, alert: "Failed to delete PD registration.")
    end
    redirect_to pd_registrations_path, success: "Deleted PD registration successfully."
  end

  private
  # This method will take in a <String name> that will be the professional_development name,
  # and return the pd; nil if doesn't exist or pd is not open
  # It assumes the pd_registrations form will have a place for the user to input the name of a pd to register for
  # But feel free to edit this if this is not the planned implementation
  def pd_name_to_pd
    professional_development = ProfessionalDevelopment.find(pd_registration_params[:name])
    if professional_development.nil? || !professional_development.registration_open
      return nil
    end
    return professional_development
  end
end
