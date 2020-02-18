# frozen_string_literal: true

class TeacherMailer < ApplicationMailer
  CONTACT_EMAIL = 'lmock@berkeley.edu'

  def welcome_email(teacher)
    @teacher = teacher
    mail to: @teacher.email,
         cc: CONTACT_EMAIL,
         subject: 'Welcome to the Beauty and Joy of Computing!'
  end

  def form_submission(teacher)
  	@teacher = teacher
  	mail to: CONTACT_EMAIL, subject: "A New Teacher Has Requested Access to BJC"
  end
end
