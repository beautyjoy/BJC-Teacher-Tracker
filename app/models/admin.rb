class Admin < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true

  attr_encrypted_options.merge!(:key => Figaro.env.attr_encrypted_key!)
  attr_encrypted :google_token
  attr_encrypted :google_refresh_token

  ADMIN_EMAILS = Rails.application.secrets.admin_emails&.split(',').freeze

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |administrator|
      administrator.first_name = auth.info.first_name
      administrator.last_name = auth.info.last_name
      administrator.email = auth.info.email
    end
  end

  def self.validate_auth(auth)
    return ADMIN_EMAILS.include?(auth.info.email.downcase)
  end
end
