# frozen_string_literal: true

class TeacherMailer < ApplicationMailer
  CONTACT_EMAIL = "Lauren Mock <lmock@berkeley.edu>"
  BJC_EMAIL = "BJC <contact@bjc.berkeley.edu>"

  before_action :email_template
  default content_type: "text/html",
          template_name: "main"

  def welcome_email(teacher)
    @teacher = teacher
    set_body
    mail to: teacher.email_name,
         cc: CONTACT_EMAIL,
         subject: email_template.subject
  end

  def deny_email(teacher, reason)
    @teacher = teacher
    @reason = reason
    set_body
    mail to: @teacher.email_name,
         cc: CONTACT_EMAIL,
         subject: email_template.subject
  end

  def request_info_email(teacher, reason)
    @teacher = teacher
    @reason = reason
    set_body
    mail to: @teacher.email_name,
         cc: CONTACT_EMAIL,
         subject: email_template.subject
  end

  def form_submission(teacher)
    @teacher = teacher
    set_body
    if @teacher.not_reviewed?
      mail to: CONTACT_EMAIL,
           subject: email_template.subject
    end
  end

  private
  def liquid_assigns
    {
      teacher_first_name: @teacher.first_name,
      teacher_last_name: @teacher.last_name,
      teacher_email: @teacher.email,
      teacher_more_info: @teacher.more_info,
      teacher_school_name: @teacher.school.name,
      teacher_school_city: @teacher.school.city,
      teacher_school_state: @teacher.school.state,
      teacher_snap: @teacher.snap,
      teacher_school_website: @teacher.school.website,
      bjc_password: Rails.application.secrets[:bjc_password],
      piazza_password: Rails.application.secrets[:piazza_password],
      reason: @reason
    }.with_indifferent_access
  end

  def email_template
    @email_template ||= EmailTemplate.find_by(title: action_name.titlecase)
  end

  def set_body
    @body = Liquid::Template.parse(email_template.body).render(liquid_assigns).html_safe
  end
end
