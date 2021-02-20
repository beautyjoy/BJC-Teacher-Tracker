# frozen_string_literal: true

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

  ADMIN_EMAILS = Rails.application.secrets.admin_emails&.split(',').freeze

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

  def self.admin_from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    admin = where(email: auth.info.email).first_or_initialize do |administrator|
      administrator.first_name = auth.info.first_name
      administrator.last_name = auth.info.last_name
      administrator.email = auth.info.email
    end
    admin.admin = true
    return admin
  end

  def self.validate_auth(auth)
    email_from_auth = auth.info.email.downcase
    return ADMIN_EMAILS.include?(email_from_auth) || exists?(email: email_from_auth)
  end
end
