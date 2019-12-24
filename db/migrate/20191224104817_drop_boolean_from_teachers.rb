class DropBooleanFromTeachers < ActiveRecord::Migration
  def change
    remove_column :teachers, :boolean
    remove_column :teachers, :school_name
  end
end
