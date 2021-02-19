class AddNumDeniedTeachersToSchools < ActiveRecord::Migration[5.2]
  def change
    add_column :schools, :num_denied_teachers, :integer, default: 0
  end
end
