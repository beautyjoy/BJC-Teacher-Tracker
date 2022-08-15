# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  layout "dynamic_page", only: :show

  def index
    @dynamic_pages = DynamicPage.where(permissions: viewable_pages)
  end

  def delete
    DynamicPage.destroy(params[:id])
    redirect_to dynamic_pages_path
  end

  def new
    @dynamic_page = DynamicPage.new
  end

  def create
    @dynamic_page = DynamicPage.new(dynamic_page_params)
    @dynamic_page.creator_id = current_user.id
    @dynamic_page.last_editor = current_user.id

    if @dynamic_page.save
      flash[:success] = "Created #{@dynamic_page.title} page successfully."
      redirect_to action: "show", slug: @dynamic_page.slug
    else
      flash.now[:alert] = "An error occurred! #{@dynamic_page.errors.full_messages}"
      render "new"
    end
  end

  def show
    @dynamic_page = DynamicPage.find_by(slug: params[:slug])

    if @dynamic_page.admin_permissions? && !is_admin?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    elsif @dynamic_page.verified_teacher_permissions? && !is_admin? && !is_verified_teacher?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    end
    render_html_body
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
  def load_page
  end

  def dynamic_page_params
    params.require(:dynamic_page).permit(:slug, :body, :html, :title, :permissions)
  end

  def viewable_pages
    if is_admin?
      ["Admin", "Verified Teacher", "Public"]
    elsif is_verified_teacher?
      ["Verified Teacher", "Public"]
    else
      ["Public"]
    end
  end

    # def liquid_assigns
  #   {
  #     teacher_first_name: @teacher.first_name,
  #     teacher_last_name: @teacher.last_name,
  #     teacher_email: @teacher.email,
  #     teacher_more_info: @teacher.more_info,
  #     teacher_school_name: @teacher.school.name,
  #     teacher_school_city: @teacher.school.city,
  #     teacher_school_state: @teacher.school.state,
  #     teacher_snap: @teacher.snap,
  #     teacher_school_website: @teacher.school.website,
  #     bjc_password: Rails.application.secrets[:bjc_password],
  #     piazza_password: Rails.application.secrets[:piazza_password],
  #     reason: @reason
  #   }.with_indifferent_access
  # end

  def render_html_body
    @content ||= Liquid::Template.parse(@dynamic_page.html).render({}).html_safe
  end
end
