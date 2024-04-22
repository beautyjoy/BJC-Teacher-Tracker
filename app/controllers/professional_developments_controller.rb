# frozen_string_literal: true

class ProfessionalDevelopmentsController < ApplicationController
  before_action :set_professional_development, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  before_action :require_admin

  def index
    @professional_developments = ProfessionalDevelopment.all
  end

  def show
  end

  def new
    @professional_development = ProfessionalDevelopment.new
  end

  def edit
  end

  def create
    @professional_development = ProfessionalDevelopment.new(professional_development_params)

    if @professional_development.save
      redirect_to @professional_development, notice: "Professional development created successfully."
    else
      flash.now[:alert] = @professional_development.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @professional_development.update(professional_development_params)
      redirect_to @professional_development, notice: "Professional development updated successfully."
    else
      flash.now[:alert] = @professional_development.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @professional_development.destroy
      redirect_to professional_developments_url, notice: "Professional development deleted successfully."
    else
      redirect_to professional_developments_url, alert: "Failed to delete professional development."
    end
  end

  private
  def set_professional_development
    @professional_development = ProfessionalDevelopment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to professional_developments_url, alert: "Professional development not found."
  end

  def professional_development_params
    params.require(:professional_development).permit(:name, :city, :state, :country, :start_date, :end_date,
                                                     :grade_level)
  end
end
