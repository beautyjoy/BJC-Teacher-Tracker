# frozen_string_literal: true

# == Schema Information
#
# Table name: professional_developments
#
#  id             :integer          not null, primary key
#  city           :string
#  country        :string
#  grade_level    :integer
#  lat            :float
#  lng            :float
#  name           :string
#  state          :string
#  teachers_count :integer          default(0)
#  website        :string           TODO: Confirm is it necessary field
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  TODO: Define indexes

# This class is a mock representation of the ProfessionalDevelopment model.
# In the final application, Professional Developments and Teachers are associated through PdRegistrations.
# This mock setup uses arrays of mock PdRegistration objects to simulate many-to-many relationships.
class ProfessionalDevelopment
  include ActiveModel::Model
  include ActiveModel::Attributes # Make sure this is included

  # Define attributes
  attribute :id, :integer
  attribute :name, :string
  attribute :city, :string
  attribute :state, :string
  attribute :country, :string
  attribute :start_date, :date
  attribute :end_date, :date
  attribute :grade_level, :integer, default: -1
  attribute :teachers_count, :integer, default: 0
  attribute :registration_open, :boolean
  attribute :pd_registrations, default: []

  validates :name, presence: { message: "can't be blank" }, uniqueness: { message: "must be unique" }

  GRADE_LEVELS = {
    elementary: 0,
    middle_school: 1,
    high_school: 2,
    community_college: 3,
    university: 4
  }.freeze

  has_many :pd_registrations
  has_many :teachers, through: :pd_registrations

  def initialize(attributes = {})
    super(attributes)
    # Now ActiveModel handles attributes, no need to manually set defaults for attributes defined above
  end

  def persisted?
    id.present?
  end

  def location
    "#{city}, #{state}, #{country}"
  end

  def display_grade_level
    # Directly access the grade_level attribute
    grade_level_value = self.grade_level
    return "Unknown" if grade_level_value == -1

    GRADE_LEVELS.key(grade_level_value).to_s.titlecase
  end
end
