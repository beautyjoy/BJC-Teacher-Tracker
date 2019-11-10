class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |a|
      a.string :first_name
      a.string :last_name
      a.string :email
      a.string :google_token
      a.string :google_refresh_token
    end
  end
end
