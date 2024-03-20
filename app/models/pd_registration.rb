# frozen_string_literal: true

class PdRegistration
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :teacher_id, :integer
  attribute :pd_id, :integer
  attribute :attended, :boolean
  attribute :role, :string
  attribute :teacher_name, :string # Adding this for convenience in mocking

  def initialize(attributes = {})
    super(attributes)
  end
end
