# frozen_string_literal: true

# This class is a mock representation of the PdRegistration model.
# In the final application, Professional Developments and Teachers are associated through PdRegistrations.
class PdRegistration
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :teacher_id, :integer
  attribute :pd_id, :integer
  attribute :attended, :boolean
  attribute :role, :string
  attribute :teacher_name, :string # Adding this for convenience in mocking

  # probably don't need the 3 id attributes (id, teacherid, pdid) if adding this relationship status into model
  belongs_to :professional_development
  belongs_to :teacher

  validates :professional_development_id, uniqueness: { scope: :teacher_id, message: "Teacher already has a registration for this PD" }

  def initialize(attributes = {})
    super(attributes)
  end
end
