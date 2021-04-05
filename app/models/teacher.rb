# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id                                :bigint           not null, primary key
#  admin                             :boolean          default(FALSE)
#  application_status                :string           default("pending")
#  education_level                   :integer          default(NULL)
#  email                             :string
#  encrypted_google_refresh_token    :string
#  encrypted_google_refresh_token_iv :string
#  encrypted_google_token            :string
#  encrypted_google_token_iv         :string
#  first_name                        :string
#  last_name                         :string
#  more_info                         :string
#  personal_website                  :string
#  snap                              :string
#  status                            :integer
#  created_at                        :datetime
#  updated_at                        :datetime
#  school_id                         :integer
#
# Indexes
#
#  index_teachers_on_email                 (email) UNIQUE
#  index_teachers_on_email_and_first_name  (email,first_name)
#  index_teachers_on_school_id             (school_id)
#  index_teachers_on_status                (status)
#
class Teacher < ApplicationRecord
  validates :first_name, :last_name, :email, :status, presence: true

  enum application_status: {
    validated: "Validated",
    denied: "Denied",
    pending: "Pending"
  }
  validates_inclusion_of :application_status, :in => application_statuses.keys

  belongs_to :school, counter_cache: true

  # Non-admin teachers who have not been denied nor accepted
  scope :unvalidated, -> { where('application_status=? AND admin=?', application_statuses[:pending], 'false') }
  # Non-admin teachers who have been accepted/validated
  scope :validated, -> { where('application_status=? AND admin=?', application_statuses[:validated], 'false') }

  # TODO: Replace these with names that are usable as methods.
  # Add a second function to return status: form description
  enum status: [
    'I am teaching BJC as an AP CS Principles course.',
    'I am teaching BJC but not as an AP CS Principles course.',
    'I am using BJC as a resource, but not teaching with it.',
    'I am a TEALS volunteer, and am teaching the BJC curriculum.',
    'I am teaching BJC through the TEALS program.',
    'I am a BJC curriculum or tool developer.',
    'Other - Please specify below.'
  ].freeze

  enum education_level: [
    'Middle School',
    'High School',
    'College'
  ].freeze

  SHORT_STATUS = [
    'CSP Teacher',
    'Non-CSP Teacher',
    'Mixed Class',
    'TEALS Volunteer',
    'TEALS Teacher',
    'Curriculum/Tool Developer',
    'Other'
  ].freeze

  EDUCATION_LEVELS = [
    'Middle School',
    'High School',
    'College'
  ].freeze


  attr_encrypted_options.merge!(:key => Figaro.env.attr_encrypted_key!)
  attr_encrypted :google_token
  attr_encrypted :google_refresh_token

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_name
    "#{full_name} <#{email}>"
  end

  def status=(value)
    value = value.to_i if value.is_a?(String)
    super(value)
  end

  def display_education_level
    if education_level_before_type_cast.to_i == -1
      return "Unknown"
    else
      return EDUCATION_LEVELS[education_level_before_type_cast.to_i]
    end
  end

  def display_status
    return "#{SHORT_STATUS[status_before_type_cast]} | #{more_info}" if more_info?
    SHORT_STATUS[status_before_type_cast]
  end

  def display_application_status
    return Teacher.application_statuses[application_status]
  end

  def self.user_from_omniauth(auth)
    find_by(email: auth.info.email)
  end

  def self.validate_access_token(auth)
    email_from_auth = auth.info.email
    return exists?(email: email_from_auth)
  end

end
