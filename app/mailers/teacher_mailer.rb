# frozen_string_literal: true

class TeacherMailer < ApplicationMailer
  CONTACT_EMAIL = 'lmock@berkeley.edu'
  BJC_EMAIL = 'contact@bjc.berkeley.edu'

  def welcome_email(teacher)
    @teacher = teacher
    mail to: @teacher.email_name,
         cc: CONTACT_EMAIL,
         subject: 'Welcome to The Beauty and Joy of Computing!'
  end

  def form_submission(teacher)
  	@teacher = teacher
  	mail to: CONTACT_EMAIL, subject: "A New Teacher Has Requested Access to BJC"
  end
end
