class CreateTeachers < ActiveRecord::Migration
  
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
    
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :course
      t.string :snap
      t.string :other
      t.references :school, foreign_key: true

      #t.string :encrypted_first_name
      #t.string :encrypted_last_name
      #t.string :encrypted_school_name
      #t.string :encrypted_email
      #t.string :encrypted_city
      #t.string :encrypted_state
      #t.string :encrypted_website
      #t.string :encrypted_course
      #t.string :encrypted_snap
      #t.string :encrypted_other

      t.timestamps null: false
    end

    # We're expecting to retrieve teachers in the same school by reverse order
    # of creation.
    add_index :teachers, [:school_id, :created_at]
  end
end
