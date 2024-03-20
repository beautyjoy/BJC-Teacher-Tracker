# frozen_string_literal: true

class PdRegistrationsController < ApplicationController
  def create
    flash[:danger] = "Create feature is not yet implemented."
    redirect_to professional_development_path(params[:professional_development_id])
  end

  def update
    flash[:danger] = "Update feature is not yet implemented."
    redirect_to professional_development_path(params[:professional_development_id])
  end

  def destroy
    flash[:danger] = "Destroy feature is not yet implemented."
    redirect_to professional_development_path(params[:professional_development_id])
  end
end
