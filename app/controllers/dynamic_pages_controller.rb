# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  def index
    if logged_in?
      @current_user_is_admin = is_admin?
      @current_user_is_teacher = is_teacher?
      @current_user_is_verified_teacher = is_verified_teacher?
    end
    @all_dynamic_pages = DynamicPage.all
  end
  def delete
    DynamicPage.destroy(params[:id])
    redirect_to dynamic_pages_path
  end
  def new
    @dynamic_page = DynamicPage.new(flash[:dynamic_page])
  end
  def create
    @dynamic_page = DynamicPage.new(dynamic_page_params)
    if DynamicPage.find_by(slug: @dynamic_page.slug)
      flash[:dynamic_page] = params[:dynamic_page]
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
    if @dynamic_page.permissions == "Admin" && !is_admin?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    elsif @dynamic_page.permissions == "Verified Teacher" && (!is_admin?) && (!is_verified_teacher?)
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    end
  end
  def edit
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
    @dynamic_page.assign_attributes(flash[:dynamic_page])
  end
  def update
    @dynamic_page ||= DynamicPage.find(params[:id])
    temp_slug = @dynamic_page.slug
    @dynamic_page.assign_attributes(dynamic_page_params)
    byebug
    if temp_slug == @dynamic_page.slug # Slug didn't change
      @dynamic_page.save
      flash[:success] = "Updated #{@dynamic_page.title} page successfully."
      redirect_to dynamic_pages_path
    elsif not DynamicPage.find_by(slug: @dynamic_page.slug) # No other page with this slug in db
      @dynamic_page.save
      flash[:success] = "Updated #{@dynamic_page.title} page successfully."
      redirect_to dynamic_pages_path
    elsif DynamicPage.find_by(slug: @dynamic_page.slug) # There is another page with this slug already
      flash[:dynamic_page] = params[:dynamic_page]
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
      params.require(:dynamic_page).require(:creator_id)
      params.require(:dynamic_page).require(:last_editor)
      params.require(:dynamic_page).permit(:slug, :body, :title, :permissions, :creator_id, :last_editor)
    end
end
