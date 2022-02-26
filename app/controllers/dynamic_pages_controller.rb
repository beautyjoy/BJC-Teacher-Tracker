# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin
  def index
    @all_dynamic_pages = DynamicPagesController.all
  end

  def new
    DynamicPage.create_dynamic_page(dynamic_page_params)
    redirect_to email_templates_path
  end

  def show
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
  end

  private
    def dynamic_page_params
      params.require(:slug).permit(:body, :subject, :permissions)
    end
end
