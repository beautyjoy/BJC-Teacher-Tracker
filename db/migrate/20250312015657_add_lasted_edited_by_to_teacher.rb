class AddLastedEditedByToTeacher < ActiveRecord::Migration[6.1]
  def change
    add_reference :teachers, :verified_by, foreign_key: { to_table: :teachers }, null: true
    add_reference :teachers, :last_editor, foreign_key: { to_table: :teachers }, null: true
  end
end
