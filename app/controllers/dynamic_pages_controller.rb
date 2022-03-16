# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin
  def index
    @all_dynamic_pages = DynamicPage.all
  end
  def delete
    if !is_admin?
      redirect_to dynamic_pages_path, alert: "Only administrators can delete!"
    else
      DynamicPage.destroy(params[:id])
      redirect_to dynamic_pages_path
    end
  end
  def new
    @dynamic_page = DynamicPage.new
  end
  def create
    @dynamic_page = DynamicPage.new(dynamic_page_params)
    if DynamicPage.find_by(slug: @dynamic_page.slug)
      redirect_to({ action: "new" }, alert:  "That slug already exists :(")
    elsif @dynamic_page.save
      flash[:success] = "Created #{@dynamic_page.title} page successfully."
      redirect_to ({ action: "show", slug: @dynamic_page.slug })
    else
      redirect_to root_path, alert: "Failed to submit information :("
    end
  end
  def show
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
  end
  def edit
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
  end
  def update
    @dynamic_page ||= DynamicPage.find(params[:id])
    temp_slug = @dynamic_page.slug
    @dynamic_page.assign_attributes(dynamic_page_params)
    if temp_slug == @dynamic_page.slug
      # redirect_to({ action: "edit", slug: temp_slug }, alert:  "That slug already exists :(")
      @dynamic_page.save
      redirect_to dynamic_pages_path
    elsif not DynamicPage.find_by(slug: @dynamic_page.slug) # nil?
      flash[:success] = "Updated #{@dynamic_page.title} page successfully."
      # redirect_to ({ action: "show", slug: @dynamic_page.slug })
      @dynamic_page.save
      redirect_to dynamic_pages_path
    elsif DynamicPage.find_by(slug: @dynamic_page.slug) # not nil?
      redirect_to({ action: "edit", slug: temp_slug }, alert:  "That slug already exists :(")
    else
      redirect_to root_path, alert: "Failed to submit information :("
    end

  end

  private
    def dynamic_page_params
      params.require(:dynamic_page).require(:slug)
      params.require(:dynamic_page).require(:title)
      params.require(:dynamic_page).require(:permissions)
      params.require(:dynamic_page).permit(:slug, :body, :title, :permissions, :creator_id, :last_editor)
    end
end
