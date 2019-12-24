class DropBooleanFromTeachers < ActiveRecord::Migration
  def change
    remove_column :teachers, :boolean
    remove_column :teachers, :school_name
    remove_column :schools, :teachers_count
  end
end
