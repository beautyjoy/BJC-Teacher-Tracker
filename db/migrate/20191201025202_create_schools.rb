class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :website
      t.float :lat
      t.float :lng
      t.integer :teachers_count, default: 0

      t.timestamps null: false
    end
  end
end
