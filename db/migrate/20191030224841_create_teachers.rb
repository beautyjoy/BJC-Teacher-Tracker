class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :encrypted_first_name
      t.string :encrypted_last_name
      t.string :encrypted_school_name
      t.string :encrypted_email
      t.string :encrypted_city
      t.string :encrypted_state
      t.string :encrypted_website
      t.string :encrypted_course
      t.string :encrypted_snap
      t.string :encrypted_other

      t.timestamps null: false
    end
  end
end
