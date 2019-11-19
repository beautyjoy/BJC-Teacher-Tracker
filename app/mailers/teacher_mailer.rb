class TeacherMailer < ApplicationMailer
    default from: 'developer.murthy@gmail.com'
 
  def welcome_email(email)
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end
end
