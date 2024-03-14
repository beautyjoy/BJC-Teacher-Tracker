class AddPersonalEmailToTeachers < ActiveRecord::Migration[6.1]
  def change
    add_column :teachers, :personal_email, :string
    add_index :teachers, [:email, :personal_email], unique: true
  end
end
