class AddGoogleOAuth < ActiveRecord::Migration
  # ActiveRecord::Migration
  def change
    add_column :teachers, 'google_token', :string
    add_column :teachers, 'google_refresh_token', :string
  end
end
