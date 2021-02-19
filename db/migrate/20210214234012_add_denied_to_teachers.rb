class AddDeniedToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :denied, :boolean
  end
end
