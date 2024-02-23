class ChangeToFieldForFormSubmission < ActiveRecord::Migration[6.1]
  def change
    EmailTemplate.find_by(path: "teacher_mailer/form_submission").update(to: "lmock@berkeley.edu, contact@bjc.berkeley.edu")
  end
end
