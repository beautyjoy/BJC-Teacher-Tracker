class DeleteOldColumnsFromSchoolsPages < ActiveRecord::Migration[6.1]
  def change
    remove_column :schools, :num_denied_teachers
    remove_column :schools, :num_validated_teachers
    drop_table :dynamic_pages
  end
end
