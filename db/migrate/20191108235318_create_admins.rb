class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |a|
      a.string :first_name
      a.string :last_name
      a.string :email
      a.string :encrypted_google_token
      # _iv column is necessary here for each encrypted column because attr_encrypted needs
      # an initialization vector for its initialization method. We don't have to access it
      # anywhere else in ActiveRecord. Blog posts prior to probably 2016 may not mention this
      # entry, since the default encryption method didn't require an _iv.
      a.string :encrypted_google_token_iv
      a.string :encrypted_google_refresh_token
      a.string :encrypted_google_refresh_token_iv
    end
  end
end
