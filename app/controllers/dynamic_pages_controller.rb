# frozen_string_literal: true

class DynamicPagesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :load_dynamic_page
  layout "dynamic_page"

  def index; end

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
    if @dynamic_page.admin_permissions? && !is_admin?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    elsif @dynamic_page.verified_teacher_permissions? && !is_admin? && !is_verified_teacher?
      redirect_to dynamic_pages_path, alert: "You do not have permission to view that page!"
    end
    render_html_body
  end

  def edit; end

  def update
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

  def delete
    @dynamic_page.destroy(params[:id])
    redirect_to dynamic_pages_path, notice: "Page #{@dynamic_page.title} was deleted."
  end

  private
  def load_dynamic_page
    @dynamic_pages ||= DynamicPage.where(permissions: DynamicPage.viewable_pages(current_user))
    if params[:id]
      @dynamic_page ||= DynamicPage.find_by(id: params[:id])
    elsif params[:slug]
      @dynamic_page ||= DynamicPage.find_by(slug: params[:slug])
    end
  end

  def dynamic_page_params
    params.require(:dynamic_page).permit(:slug, :html, :title, :permissions)
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
