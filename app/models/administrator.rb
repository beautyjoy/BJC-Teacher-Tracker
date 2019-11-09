class Administrator < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |administrator|
      administrator.first_name = auth.info.name
      administrator.email = auth.info.email
    end
  end
end
