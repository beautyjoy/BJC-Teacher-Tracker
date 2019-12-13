class Teacher < ActiveRecord::Base
  validates :first_name, :last_name, :email, :course, presence: true
  validates_inclusion_of :validated, :in => [true, false]

  belongs_to :school, counter_cache: true

  def self.unvalidated
    Teacher.where(:validated => false)
  end
end
