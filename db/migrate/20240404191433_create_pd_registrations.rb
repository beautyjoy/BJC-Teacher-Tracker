class CreatePdRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :pd_registrations do |t|
      t.integer :teacher_id, null: false
      t.integer :professional_development_id, null: false
      t.boolean :attended, default: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :pd_registrations, [:teacher_id, :professional_development_id], unique: true,
              name: 'index_pd_reg_on_teacher_id_and_pd_id'
    add_foreign_key :pd_registrations, :teachers
    add_foreign_key :pd_registrations, :professional_developments
  end
end
