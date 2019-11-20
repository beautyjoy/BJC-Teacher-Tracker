class TeacherMailer < ApplicationMailer
 
  def welcome_email(teacher)
  	@teacher = teacher
    mail(to: @teacher.email, subject: 'Welcome to My Awesome Site')
  end
end
