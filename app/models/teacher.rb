class Teacher < ActiveRecord::Base
  validates :first_name, :last_name, :email, :course, :snap, :other, presence: true
  validates_inclusion_of :validated, :in => [true, false]

  belongs_to :school, counter_cache: true

  #attr_encrypted_options.merge!(:encode => true)
  #attr_encrypted :first_name, :key => SecureRandom.base64(32).first(32)
  #ENV["USERKEY"]
  #attr_encrypted :last_name, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :school_name, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :email, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :city, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :state, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :website, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :course, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :snap, :key => SecureRandom.base64(32).first(32)
  #attr_encrypted :other, :key => SecureRandom.base64(32).first(32)

  def self.from_omniauth(auth)
    # Creates a new teacher only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |teacher|
      teacher.first_name = auth.info.first_name
      teacher.last_name = auth.info.last_name
      teacher.email = auth.info.email
    end
  end

  def self.unvalidated
    Teacher.where(:validated => false)
  end
end
