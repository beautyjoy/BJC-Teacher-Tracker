class AddToFieldToEmailTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :email_templates, :to, :string
    #below is the default prepopulated 'to' field value,
    to_field = "{{teacher_email}}, {{teacher_personal_email}}"
    EmailTemplate.update_all(to: to_field)
  end
end
