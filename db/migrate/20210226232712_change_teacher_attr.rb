class ChangeTeacherAttr < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :teachers, :google_token, :encrypted_google_token
    rename_column :teachers, :google_token_iv, :encrypted_google_token_iv
    rename_column :teachers, :google_refresh_token, :encrypted_google_refresh_token
    rename_column :teachers, :google_refresh_token_iv, :encrypted_google_refresh_token_iv
  end

  def self.down
    rename_column :teachers, :encrypted_google_token, :google_token
    rename_column :teachers, :encrypted_google_token_iv, :google_token_iv
    rename_column :teachers, :encrypted_google_refresh_token, :google_refresh_token 
    rename_column :teachers, :encrypted_google_refresh_token_iv, :google_refresh_token_iv
  end
end
