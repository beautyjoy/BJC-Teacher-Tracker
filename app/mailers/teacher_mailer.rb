class TeacherMailer < ApplicationMailer
 
  def welcome_email(teacher)
  	@teacher = teacher
    mail(to: @teacher.email, subject: 'Welcome to the Beauty and Joy of Computing!')
  end

  def form_submission(teacher)
  	@teacher = teacher
  	mail(to: "beautyandjoy2019@gmail.com", subject: "A Teacher has submitted a new BJC form")
  end
end
