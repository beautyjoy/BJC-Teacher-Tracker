# frozen_string_literal: true

# == Schema Information
#
# Table name: professional_developments
#
#  id          :bigint           not null, primary key
#  city        :string           not null
#  country     :string           not null
#  end_date    :date             not null
#  grade_level :integer          not null
#  name        :string           not null
#  start_date  :date             not null
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ProfessionalDevelopment < ApplicationRecord
  VALID_STATES = %w[AL AK AS AZ AR CA CO CT DE DC FM FL GA GU HI ID IL IN IA KS KY LA ME MH MD MA MI MN MS MO MT NE NV
                    NH NJ NM NY NC ND MP OH OK OR PW PA PR RI SC SD TN TX UT VT VI VA WA WV WI WY].freeze

  validates :name, :city, :country, :start_date, :end_date, presence: true
  validates :state, presence: true, if: -> { country == "US" }
  validates :state, inclusion: { in: VALID_STATES, message: "%{value} is not a valid state" },
            if: -> { country == "US" }
  validate :end_date_after_start_date

  enum grade_level: {
    elementary: 0,
    middle_school: 1,
    high_school: 2,
    community_college: 3,
    university: 4
  }

  has_many :pd_registrations, dependent: :destroy
  has_many :teachers, through: :pd_registrations

  def location
    "#{city}, #{state}, #{country}"
  end

  def display_grade_level
    return "Unknown" if grade_level_before_type_cast.to_i == -1

    grade_level.to_s.titlecase
  end

  def registration_open
    @professional_development.registration_open ? "Yes" : "No"
  end

  private
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end
end
