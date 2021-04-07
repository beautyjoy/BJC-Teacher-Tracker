class ChangeEmailUnique < ActiveRecord::Migration[5.2]
  def up
    add_index :teachers, :email, unique: true
  end

  def down
    remove_index :teachers, :email
  end
end
