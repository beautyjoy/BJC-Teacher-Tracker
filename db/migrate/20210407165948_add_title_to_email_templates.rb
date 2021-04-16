class AddTitleToEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :email_templates, :title, :string
  end
end
