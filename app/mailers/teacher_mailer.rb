class TeacherMailer < ApplicationMailer
 
  def welcome_email(teacher)
  	@teacher = teacher
    mail(to: @teacher.email, subject: 'Welcome to the Beauty and Joy of Computing!')
  end
end
