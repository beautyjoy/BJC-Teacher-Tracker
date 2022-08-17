# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :load_page
  layout "page_with_sidebar"

  def index; end

  def new
    @page = Page.new
    render 'edit'
  end

  def create
    @page = Page.new(page_params)
    @page.creator_id = current_user.id
    @page.last_editor = current_user.id

    if @page.save
      flash[:success] = "Created #{@page.title} page successfully."
      redirect_to action: "show", slug: @page.slug
    else
      flash.now[:alert] = "An error occurred! #{@page.errors.full_messages}"
      render "new"
    end
  end

  def show
    if @page.admin_permissions? && !is_admin?
      redirect_to pages_path, alert: "You do not have permission to view that page!"
    elsif @page.verified_teacher_permissions? && !is_admin? && !is_verified_teacher?
      redirect_to pages_path, alert: "You do not have permission to view that page!"
    end
    render_html_body
  end

  def edit; end

  def update
    @page.assign_attributes(page_params)
    @page.last_editor = current_user.id

    if @page.save
      flash[:success] = "Updated #{@page.title} page successfully."
      redirect_to pages_path
    else
      flash.now[:alert] = "An error occurred! #{@page.errors.full_messages}"
      render "edit"
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path, notice: "Page #{@page.title} was deleted."
  end

  private
  def load_page
    @pages ||= Page.where(permissions: Page.viewable_pages(current_user))
    if params[:id]
      @page ||= Page.find_by(id: params[:id])
    elsif params[:slug]
      @page ||= Page.find_by(slug: params[:slug])
    end
  end

  def page_params
    params.require(:page).permit(:slug, :html, :title, :permissions)
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
    @content ||= Liquid::Template.parse(@page.html).render({}).html_safe
  end
end
