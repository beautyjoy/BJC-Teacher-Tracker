# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @dynamic_pages = DynamicPage.where(permissions: get_permissions)
  end

  def delete
    DynamicPage.destroy(params[:id])
    redirect_to dynamic_pages_path
  end

  def new
    @dynamic_page = DynamicPage.new()
  end

  def create
    @dynamic_page = DynamicPage.new(dynamic_page_params)
    @dynamic_page.creator_id = current_user.id
    @dynamic_page.last_editor = current_user.id

    if @dynamic_page.save
      flash[:success] = "Created #{@dynamic_page.title} page successfully."
      redirect_to ({ action: "show", slug: @dynamic_page.slug })
    else
      flash.now[:alert] = "An error occurred! #{@dynamic_page.errors.full_messages}"
      render "new"
    end
  end

  def show
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
    if @dynamic_page.admin_permissions? && !is_admin?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    elsif @dynamic_page.verified_teacher_permissions? && (!is_admin?) && (!is_verified_teacher?)
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    end
  end

  def edit
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])
  end

  def update
    @dynamic_page ||= DynamicPage.find(params[:id])
    @dynamic_page.assign_attributes(dynamic_page_params)
    @dynamic_page.last_editor = current_user.id

    if @dynamic_page.save
      flash[:success] = "Updated #{@dynamic_page.title} page successfully."
      redirect_to dynamic_pages_path
    else
      flash.now[:alert] = "An error occurred! #{@dynamic_page.errors.full_messages}"
      render "edit"
    end
  end

  private
  def dynamic_page_params
    params.require(:dynamic_page).permit(:slug, :body, :title, :permissions)
  end

  def get_permissions
    if is_admin?
      @permissions ||= ["Admin", "Verified Teacher", "Public"]
    elsif is_verified_teacher?
      @permissions ||= ["Verified Teacher", "Public"]
    else
      @permissions ||= ["Public"]
    end
  end
end
