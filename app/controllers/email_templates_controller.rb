# frozen_string_literal: true

class EmailTemplatesController < ApplicationController
  before_action :require_admin

  def index
    load_ordered_email_templates
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  def update
    template = EmailTemplate.find(params[:id])
    template.update(template_params)
    if template.save
      flash[:success] = "Updated #{template.title} template successfully."
      redirect_to email_templates_path
    else
      flash[:alert] = "Failed to save #{template.title} template: " + template.errors.full_messages.join(', ')
      redirect_to edit_email_template_path(params[:id])
    end
  end

  def create
    @email_template = EmailTemplate.find_by(title: template_params[:title])
    if @email_template
      @email_template.assign_attributes(template_params)
    else
      @email_template = EmailTemplate.new(template_params)
    end
    load_ordered_email_templates

    if @email_template.save
      flash[:success] = "Created #{@email_template.title} successfully."
      redirect_to email_templates_path
    else
      flash[:alert] = "Failed to submit information: " + @email_template.errors.full_messages.join(', ')
      render "new"
    end
  end

  def new
    @email_template = EmailTemplate.new
    load_ordered_email_templates
  end

  def destroy
    @email_template = EmailTemplate.find(params[:id])
    @email_template.destroy
    redirect_to email_templates_path, notice: "Deleted \"#{@email_template.subject}\" successfully."
  end

  private
  def template_params
    params.require(:email_template).permit(:body, :subject, :title, :to)
  end

  def load_ordered_email_templates
    @ordered_email_templates ||= EmailTemplate.all.order(:title)
  end
end
