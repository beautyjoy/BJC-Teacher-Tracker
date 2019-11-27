class Teacher < ActiveRecord::Base
  validates :first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap, :other, presence: true

  
  # attr_encrypted_options.merge!(:encode => true)
  # attr_encrypted :first_name, :key => Figaro.env.FIRST_NAMEKEY
  # ENV["USERKEY"]
  # attr_encrypted :last_name, :key => Figaro.env.LAST_NAMEKEY
  # attr_encrypted :school_name, :key => Figaro.env.SCHOOL_NAMEKEY
  # attr_encrypted :email, :key => Figaro.env.EMAILKEY
  # attr_encrypted :city, :key => Figaro.env.CITYKEY
  # attr_encrypted :state, :key => Figaro.env.STATEKEY
  # attr_encrypted :website, :key => Figaro.env.WEBSITEKEY
  # attr_encrypted :course, :key => Figaro.env.COURSEKEY
  # attr_encrypted :snap, :key => Figaro.env.SNAPKEY

  attr_encrypted_options.merge!(:encode => true)
  attr_encrypted :first_name, :key => SecureRandom.base64(32).first(32)
  ENV["USERKEY"]
  attr_encrypted :last_name, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :school_name, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :email, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :city, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :state, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :website, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :course, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :snap, :key => SecureRandom.base64(32).first(32)
  attr_encrypted :other, :key => SecureRandom.base64(32).first(32)

  def self.from_omniauth(auth)
    # Creates a new teacher only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |teacher|
      teacher.first_name = auth.info.first_name
      teacher.last_name = auth.info.last_name
      teacher.email = auth.info.email
    end
  end

end
