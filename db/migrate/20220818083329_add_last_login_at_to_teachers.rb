class AddLastLoginAtToTeachers < ActiveRecord::Migration[6.1]
  def change
    add_column :teachers, :last_session_at, :datetime
  end
end
