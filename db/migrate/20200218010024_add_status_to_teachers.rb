class AddStatusToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :status, :integer
  end
end
