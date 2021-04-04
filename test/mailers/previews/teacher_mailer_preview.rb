# Preview all emails at http://localhost:3000/rails/mailers/teacher_mailer
class TeacherMailerPreview < ActionMailer::Preview
    def welcome_email
        teacher = Teacher.first
        TeacherMailer.welcome_email(teacher)
    end

    def teals_confirmation_email
        teacher = Teacher.find_by(first_name: 'AAA')
        TeacherMailer.teals_confirmation_email(teacher)
    end

    def form_submission
        teacher = Teacher.find_by(first_name: 'AAA')
        TeacherMailer.form_submission(teacher)
    end
end
