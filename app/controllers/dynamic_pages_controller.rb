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
    @dynamic_page.creator_id = session[:user_id]
    @dynamic_page.last_editor = session[:user_id]
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
    @dynamic_page.assign_attributes(flash[:dynamic_page]) # Assigns attrs if tried to use duplicate slug and redirected here
  end
  def update
    @dynamic_page ||= DynamicPage.find(params[:id])
    @dynamic_page.assign_attributes(dynamic_page_params)
    @dynamic_page.last_editor = session[:user_id]

    if @dynamic_page.slug_changed? && DynamicPage.find_by(slug: @dynamic_page.slug)
      flash[:dynamic_page] = params[:dynamic_page]
      redirect_to({ action: "edit", slug: @dynamic_page.slug_was }, alert:  "That slug already exists :(")
    elsif @dynamic_page.save
      flash[:success] = "Updated #{@dynamic_page.title} page successfully."
      redirect_to dynamic_pages_path
    else
      flash[:alert] = "An error occurred! #{@dynamic_page.errors.full_messages}"
      redirect_to dynamic_pages_path
    end
  end

  private
    def dynamic_page_params
      params.require(:dynamic_page).permit(:slug, :body, :title, :permissions)
    end
end
