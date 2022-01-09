# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id                                :bigint           not null, primary key
#  admin                             :boolean          default(FALSE)
#  application_status                :string           default("pending")
#  clever_refresh_token              :string
#  clever_token                      :string
#  education_level                   :integer          default(NULL)
#  email                             :string
#  encrypted_google_refresh_token    :string
#  encrypted_google_refresh_token_iv :string
#  encrypted_google_token            :string
#  encrypted_google_token_iv         :string
#  first_name                        :string
#  last_name                         :string
#  microsoft_refresh_token           :string
#  microsoft_token                   :string
#  more_info                         :string
#  personal_website                  :string
#  snap                              :string
#  snap_refresh_token                :string
#  snap_token                        :string
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
#  index_teachers_on_snap                  (snap) UNIQUE WHERE ((snap)::text <> ''::text)
#  index_teachers_on_status                (status)
#
class Teacher < ApplicationRecord
  validates :first_name, :last_name, :email, :status, presence: true

  enum application_status: {
    validated: 'Validated',
    denied: 'Denied',
    pending: 'Pending'
  }
  validates_inclusion_of :application_status, in: application_statuses.keys

  belongs_to :school, counter_cache: true

  # # Non-admin teachers who have not been denied nor accepted
  scope :unvalidated, -> { where('application_status=? AND admin=?', application_statuses[:pending], 'false') }
  # Non-admin teachers who have been accepted/validated
  scope :validated, -> { where('application_status=? AND admin=?', application_statuses[:validated], 'false') }

  enum education_level: {
    middle_school: 0,
    high_school: 1,
    college: 2
  }

  # The order of these two lists must match.
  # Do NOT change the values of existing options.
  enum status: {
    csp_teacher: 0,
    non_csp_teacher: 1,
    mixed_class: 2,
    teals_volunteer: 3,
    other: 4,
    teals_teacher: 5,
    developer: 6,
    excite: 7,
    middle_school_bjc: 8,
  }

  # Always add to the bottom of the list!
  STATUSES = [
    'I am teaching BJC as an AP CS Principles course.',
    'I am teaching BJC but not as an AP CS Principles course.',
    'I am using BJC as a resource, but not teaching with it.',
    'I am a TEALS volunteer, and am teaching the BJC curriculum.',
    'Other - Please specify below.',
    'I am teaching BJC through the TEALS program.',
    'I am a BJC curriculum or tool developer.',
    'I am teaching with the ExCITE project',
    'I am teaching Middle School BJC.',
  ].freeze

  attr_encrypted_options[:key] = Figaro.env.attr_encrypted_key!
  attr_encrypted :google_token
  attr_encrypted :google_refresh_token

  before_update :reset_validation_status
  after_commit :update_school_counts

  def reset_validation_status
    return if application_status_changed? || school_id_changed?
    if denied?
      pending!
    end
  end

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

  # TODO: Move these to helpers.
  def self.status_options
    display_order = [
      :csp_teacher,
      :middle_school_bjc,
      :non_csp_teacher,
      :mixed_class,
      :excite,
      :teals_teacher,
      :teals_volunteer,
      :other,
      :developer,
    ]

    display_order.map do |key|
      status_idx = statuses[key]
      [ STATUSES[status_idx], status_idx ]
    end
  end

  def self.education_level_options
    Teacher.education_levels.map { |sym, val| [sym.to_s.titlecase, val] }
  end

  def display_education_level
    if education_level_before_type_cast.to_i == -1
      'Unknown'
    else
      education_level.to_s.titlecase
    end
  end

  def text_status
    STATUSES[status_before_type_cast]
  end

  def display_status
    formatted_status = status.to_s.titlecase
    return "#{formatted_status} | #{more_info}" if more_info?
    formatted_status
  end

  def display_application_status
    Teacher.application_statuses[application_status]
  end

  def self.user_from_omniauth(auth)
    find_by(email: auth.info.email)
  end

  def self.validate_access_token(auth)
    email_from_auth = auth.info.email
    exists?(email: email_from_auth)
  end

  # TODO: Write tests, add hooks.
  # TODO: Consider writing after_destroy hooks.
  def update_school_counts
    return unless application_status_changed?
    if validated?
      school.num_validated_teachers += 1
    elsif denied?
      school.num_denied_teachers += 1
    end
    if application_status_was == 'validated'
      school.num_validated_teachers -= 1
    elsif application_status_was == 'denied'
      school.num_denied_teachers -= 1
    end
    school.save
  end
end
