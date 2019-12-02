class Admin < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  attr_encrypted_options.merge!(:key => Figaro.env.attr_encrypted_key!)
  attr_encrypted :google_token
  attr_encrypted :google_refresh_token

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |administrator|
      administrator.first_name = auth.info.first_name
      administrator.last_name = auth.info.last_name
      administrator.email = auth.info.email
    end
  end
end
