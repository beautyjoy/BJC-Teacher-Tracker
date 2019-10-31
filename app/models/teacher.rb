class Teacher < ActiveRecord::Base
    validates :first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap, presence: true
end
