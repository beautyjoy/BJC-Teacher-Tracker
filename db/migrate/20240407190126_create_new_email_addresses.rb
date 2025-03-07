class CreateNewEmailAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :email_addresses do |t|
      t.references :teacher, null: false, foreign_key: true
      t.string :email, null: false
      t.boolean :primary, default: false, null: false

      t.timestamps
    end

    add_index :email_addresses, :email, unique: true
    # quickly find primary emails for teachers
    add_index :email_addresses, [:teacher_id, :primary], unique: true, where: '"primary" = TRUE'
  end
end
