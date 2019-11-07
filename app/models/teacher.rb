class Teacher < ActiveRecord::Base
  validates :first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap, presence: true

  def self.from_omniauth(auth)
    # Creates a new teacher only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |teacher|
      teacher.first_name = auth.info.name
      teacher.email = auth.info.email
    end
  end
end
