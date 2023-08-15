class AddRequiredToEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :email_templates, :required, :boolean, default: false
  end
end
