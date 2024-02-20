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
    set_recipients
    mail to: @recipients, #ActionMailer accepts comma-separated lists of emails
         cc: CONTACT_EMAIL,
         subject: email_template.subject
  end

  def deny_email(teacher, denial_reason)
    @teacher = teacher
    @denial_reason = denial_reason
    set_body
    set_recipients
    mail to: @recipients,
         cc: CONTACT_EMAIL,
         subject: email_template.subject
  end

  def request_info_email(teacher, request_reason)
    @teacher = teacher
    @request_reason = request_reason
    set_body
    set_recipients
    mail to: @recipients,
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
    base_rules = {
      bjc_password: Rails.application.secrets[:bjc_password],
      piazza_password: Rails.application.secrets[:piazza_password],
      denial_reason: @denial_reason
    }
    base_rules.merge!(@teacher.email_attributes)
    base_rules.with_indifferent_access
  end

  def email_template
    @email_template ||= EmailTemplate.find_by(title: action_name.titlecase)
  end

  #renders the email body with the {{parameter}} things
  def set_body
    @body = Liquid::Template.parse(email_template.body).render(liquid_assigns).html_safe
  end

  #renders the list of recipients with the {{parameter}} things
  def set_recipients
    @recipients = Liquid::Template.parse(email_template.to).render(liquid_assigns).html_safe
  end

end
