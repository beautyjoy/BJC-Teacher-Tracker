class DropAdmin < ActiveRecord::Migration[5.2]
  def up
    drop_table :admins
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
