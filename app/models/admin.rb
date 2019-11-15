class Admin < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  attr_encrypted_options.merge!(:encode => true)
  attr_encrypted :first_name, :key => Figaro.env.FIRST_NAMEKEY
      ENV["USERKEY"]
  attr_encrypted :last_name, :key => Figaro.env.LAST_NAMEKEY
  attr_encrypted :email, :key => Figaro.env.EMAILKEY

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |administrator|
      administrator.first_name = auth.info.first_name
      administrator.last_name = auth.info.last_name
      administrator.email = auth.info.email
    end
  end
end
