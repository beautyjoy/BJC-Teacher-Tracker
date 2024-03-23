# frozen_string_literal: true

# Not sure how the ids are going to work with professional development.
# With a belongs to relationship, depending on customer implementation,
# might have 2 ids in params that we need to distinguish between.
class PdRegistrationsController < ApplicationController
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

  def create
    @pd_registration = PdRegistration.new(pd_registration_params)
    if !@pd_registration.save
      flash.now[:alert] = "Failed to save registration: #{@pd_registration.errors.full_messages.join(", ")}"
      render :new
    end
    redirect_to pd_registrations_path, success: "PD registration created successfully."
  end

  def update
    @pd_registration = PdRegistration.find(params[:id])
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
end
