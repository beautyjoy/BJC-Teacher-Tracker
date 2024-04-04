class CreateProfessionalDevelopments < ActiveRecord::Migration[6.1]
  def change
    create_table :professional_developments do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :state
      t.string :country, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :grade_level, null: false

      t.timestamps
    end

    add_index :professional_developments, [:name, :start_date], unique: true
  end
end
