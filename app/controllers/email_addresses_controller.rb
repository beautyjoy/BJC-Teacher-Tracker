# frozen_string_literal: true

class EmailAddressesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_teacher

  def edit
  end

  def update
    if update_personal_emails
      redirect_to teacher_path(@teacher), notice: "Personal email addresses updated successfully."
    else
      flash.now[:alert] = "An error occurred: " + (@error_messages || "Unknown error")
      render :edit
    end
  end

  private
  def set_teacher
    @teacher = Teacher.find(params[:teacher_id])
  end

  def update_personal_emails
    EmailAddress.transaction do
      params[:teacher][:email_addresses_attributes].each do |_, email_attr|
        if email_attr[:id].present?
          email = EmailAddress.find(email_attr[:id])
          if email_attr[:_destroy] == "1"
            email.destroy!
          else
            email.update!(email: email_attr[:email])
          end
        else
          @teacher.email_addresses.create!(email: email_attr[:email]) unless email_attr[:email].blank?
        end
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    @error_messages = e.record&.errors&.full_messages&.join(", ")
    @error_messages ||= "A validation error occurred, but no specific error details are available."
    false
  end
end
