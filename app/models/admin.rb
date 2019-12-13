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

  def self.validate_auth(auth)
    return self.validate_by_email(auth.info.email)
  end


  private

    def self.validate_by_email(email)
      # Check if the email is in a list of all BJC Teacher Tracker administrators and
      # current developers of the app.
      admin_emails = %w(ball@berkeley.edu)
      developer_2019_emails = %w(wangye@berkeley.edu janani_vijaykumar@berkeley.edu
                    daltons@berkeley.edu murthy@berkeley.edu zachchao@berkeley.edu)
      return admin_emails.include?(email) || developer_2019_emails.include?(email)
    end
end
