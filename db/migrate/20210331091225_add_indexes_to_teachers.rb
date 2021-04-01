class AddIndexesToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_index :teachers, :school_id
    add_index :teachers, :status

    remove_column :teachers, :other
    remove_column :teachers, :course
  end
end
