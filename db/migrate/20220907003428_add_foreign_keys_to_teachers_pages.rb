class AddForeignKeysToTeachersPages < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :teachers, :schools
    add_foreign_key :pages, :teachers, column: :creator_id
    add_foreign_key :pages, :teachers, column: :last_editor_id
  end
end
