class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :school_name
      t.string :email
      t.string :city
      t.string :state
      t.string :website
      t.string :course
      t.string :snap

      t.timestamps null: false
    end
  end
end
