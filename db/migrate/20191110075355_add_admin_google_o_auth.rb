class AddAdminGoogleOAuth < ActiveRecord::Migration
  def change
    def change
      add_column :admins, 'google_token', :string
      add_column :admins, 'google_refresh_token', :string
    end
  end
end
