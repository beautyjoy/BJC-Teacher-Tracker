class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |a|
      a.string :first_name
      a.string :last_name
      a.string :email
    end
  end
end
