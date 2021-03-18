# frozen_string_literal: true

class Teacher < ApplicationRecord
  validates :first_name, :last_name, :email, :status, presence: true
  validates_inclusion_of :application_status, :in => %w(Validated Denied Pending)

  belongs_to :school, counter_cache: true

  #Non-admin teachers who have not been denied nor accepted
  scope :unvalidated, -> { where('(application_status!=? AND application_status!=?) AND admin=?', 'Validated', 'Denied', 'false') }
  #Non-admin teachers who have been accepted/validated
  scope :validated, -> { where('application_status=? AND admin=?', 'Validated', 'false') }

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

  ADMIN_EMAILS = Rails.application.secrets.admin_emails&.freeze

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
    return application_status
  end

  def self.user_from_omniauth(auth)
    user = find_or_create_by(email: auth.info.email)
    # TODO: Should be changed when we have a way to add admin without using ENV.
    if ADMIN_EMAILS =~ /#{user.email}/
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.email = auth.info.email
        user.admin = true
        user.status = 'Other'
        user.application_status = 'Validated'
    end
    return user
  end

  def self.validate_access_token(auth)
    email_from_auth = auth.info.email
    return ADMIN_EMAILS.match?(/#{email_from_auth}/) || exists?(email: email_from_auth)
  end

end
