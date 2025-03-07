class AddToFieldToEmailTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :email_templates, :to, :string
  end
end
