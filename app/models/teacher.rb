# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id                      :bigint           not null, primary key
#  admin                   :boolean          default(FALSE)
#  course                  :string
#  email                   :string
#  first_name              :string
#  google_refresh_token    :string
#  google_refresh_token_iv :string
#  google_token            :string
#  google_token_iv         :string
#  last_name               :string
#  more_info               :string
#  other                   :string
#  snap                    :string
#  status                  :integer
#  validated               :boolean
#  created_at              :datetime
#  updated_at              :datetime
#  school_id               :integer
#
# Indexes
#
#  index_teachers_on_email_and_first_name  (email,first_name)
#
class Teacher < ApplicationRecord
  validates :first_name, :last_name, :email, :status, presence: true
  validates_inclusion_of :validated, :in => [true, false]

  belongs_to :school, counter_cache: true

  scope :unvalidated, -> { where(validated: false) }
  scope :validated, -> { where(validated: true) }

  # TODO: Replace these with names that are usable as methods.
  # Add a second function to return status: form description
  enum status: [
    'I am teaching BJC as an AP CS Principles course.',
    'I am teaching BJC but not as an AP CS Principles course.',
    'I am using BJC as a resource, but not teaching with it.',
    'I am a TEALS volunteer, and am teaching the BJC curriculum.',
    'Other - Please specify below.',
    'I am teaching BJC through the TEALS program'
  ].freeze

  SHORT_STATUS = [
    'CSP Teacher',
    'Non-CSP Teacher',
    'Mixed Class',
    'TEALS Volunteer',
    'Other',
    'TEALS Teacher'
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

  def display_status
    return "#{SHORT_STATUS[status_before_type_cast]} | #{more_info}" if more_info?
    SHORT_STATUS[status_before_type_cast]
  end
end
