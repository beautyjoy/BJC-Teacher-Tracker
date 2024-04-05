class AddLanguagesToTeachers < ActiveRecord::Migration[6.1]
  def change
    add_column :teachers, :languages, :string, array: true, default: ['English']
  end
end
