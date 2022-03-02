# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin
  def index
    @all_dynamic_pages = DynamicPage.all
  end

  def new
    @dynamic_page = DynamicPage.new
  end

  def create
    @dynamic_page = DynamicPage.new(dynamic_page_params)
    if @dynamic_page.save
      flash[:success] = "Created #{@dynamic_page.title} page successfully."
      redirect_to ({ action: "show", slug: @dynamic_page.slug })
    else
      redirect_to root_path, alert: "Failed to submit information :("
    end
  end

  def show
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
  end

  private
    def dynamic_page_params
      params.require(:dynamic_page).permit(:slug, :body, :title, :permissions, :creator_id, :lasted_editor)
    end
end
