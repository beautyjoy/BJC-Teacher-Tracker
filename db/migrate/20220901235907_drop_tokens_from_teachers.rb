class DropTokensFromTeachers < ActiveRecord::Migration[6.1]
  def change
    remove_column :teachers, :clever_token
    remove_column :teachers, :clever_refresh_token
    remove_column :teachers, :encrypted_google_token
    remove_column :teachers, :encrypted_google_refresh_token
    remove_column :teachers, :encrypted_google_refresh_token_iv
    remove_column :teachers, :encrypted_google_token_iv
    remove_column :teachers, :microsoft_token
    remove_column :teachers, :microsoft_refresh_token
    remove_column :teachers, :snap_token
    remove_column :teachers, :snap_refresh_token
  end
end
