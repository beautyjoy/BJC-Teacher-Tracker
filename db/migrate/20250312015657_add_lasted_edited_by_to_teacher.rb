class AddLastedEditedByToTeacher < ActiveRecord::Migration[6.1]
  def change
    add_reference :teachers, :verifed_by_id, teachers: true, null: true, foreign_key: true
    add_reference :teachers, :last_editor_id, teachers: true, null: true, foreign_key: true
  end
end
