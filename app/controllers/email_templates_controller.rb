# frozen_string_literal: true

class EmailTemplatesController < ApplicationController
  before_action :require_admin
  def index
    @all_templates = EmailTemplate.all
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  def update
    template = EmailTemplate.find(params[:id])
    template.update(template_params)
    template.save!
    redirect_to email_templates_path
  end

  private
  def template_params
    params.require(:email_template).permit(:body, :subject)
  end
end
