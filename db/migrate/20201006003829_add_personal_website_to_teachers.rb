class AddPersonalWebsiteToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :personal_website, :string
  end
end
