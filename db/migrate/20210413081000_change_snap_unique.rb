class ChangeSnapUnique < ActiveRecord::Migration[5.2]
  def up
    add_index :teachers, :snap, unique: true
  end

  def down
    remove_index :teachers, :snap
  end
end
