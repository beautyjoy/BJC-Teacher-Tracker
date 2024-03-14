# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id                 :integer          not null, primary key
#  admin              :boolean          default(FALSE)
#  application_status :string           default("not_reviewed")
#  education_level    :integer          default(NULL)
#  email              :string
#  first_name         :string
#  ip_history         :inet             default([]), is an Array
#  languages          :string           default(["\"English\""]), is an Array
#  last_name          :string
#  last_session_at    :datetime
#  more_info          :string
#  personal_email     :string
#  personal_website   :string
#  session_count      :integer          default(0)
#  snap               :string
#  status             :integer
#  created_at         :datetime
#  updated_at         :datetime
#  school_id          :integer
#
# Indexes
#
#  index_teachers_on_email                     (email) UNIQUE
#  index_teachers_on_email_and_first_name      (email,first_name)
#  index_teachers_on_email_and_personal_email  (email,personal_email) UNIQUE
#  index_teachers_on_school_id                 (school_id)
#  index_teachers_on_snap                      (snap) UNIQUE WHERE ((snap)::text <> ''::text)
#  index_teachers_on_status                    (status)
#
# Foreign Keys
#
#  fk_rails_...  (school_id => schools.id)
#
class Teacher < ApplicationRecord

  WORLD_LANGUAGES = [ 'Afrikaans', 'Albanian', 'Arabic', 'Armenian', 'Basque', 'Bengali', 'Bulgarian', 'Catalan', 'Cambodian', 'Chinese (Mandarin)', 'Croatian', 'Czech', 'Danish', 'Dutch', 'English', 'Estonian', 'Fiji', 'Finnish', 'French', 'Georgian', 'German', 'Greek', 'Gujarati', 'Hebrew', 'Hindi', 'Hungarian', 'Icelandic', 'Indonesian', 'Irish', 'Italian', 'Japanese', 'Javanese', 'Korean', 'Latin', 'Latvian', 'Lithuanian', 'Macedonian', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi', 'Mongolian', 'Nepali', 'Norwegian', 'Persian', 'Polish', 'Portuguese', 'Punjabi', 'Quechua', 'Romanian', 'Russian', 'Samoan', 'Serbian', 'Slovak', 'Slovenian', 'Spanish', 'Swahili', 'Swedish ', 'Tamil', 'Tatar', 'Telugu', 'Thai', 'Tibetan', 'Tonga', 'Turkish', 'Ukrainian', 'Urdu', 'Uzbek', 'Vietnamese', 'Welsh', 'Xhosa' ].freeze

  validates :first_name, :last_name, :email, :status, presence: true
  validates :email, uniqueness: true
  validates :personal_email, uniqueness: true, if: -> { personal_email.present? }
  validate :ensure_unique_personal_email, if: -> { email_changed? || personal_email_changed? }

  enum application_status: {
    validated: "Validated",
    denied: "Denied",
    info_needed: "Info Needed",
    not_reviewed: "Not Reviewed",
  }
  validates_inclusion_of :application_status, in: application_statuses.keys

  belongs_to :school, counter_cache: true

  # Non-admin teachers whose application has neither been accepted nor denied
  # It might or might not have been reviewed.
  scope :unvalidated, -> { where("(application_status=? OR application_status=?) AND admin=?", application_statuses[:info_needed], application_statuses[:not_reviewed], "false") }
  scope :unreviewed, -> { where("application_status=? AND admin=?", application_statuses[:not_reviewed], "false") }
  # Non-admin teachers who have been accepted/validated
  scope :validated, -> { where("application_status=? AND admin=?", application_statuses[:validated], "false") }


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
    "I am teaching BJC as an AP CS Principles course.",
    "I am teaching BJC but not as an AP CS Principles course.",
    "I am using BJC as a resource, but not teaching with it.",
    "I am a TEALS volunteer, and am teaching the BJC curriculum.",
    "Other - Please specify below.",
    "I am teaching BJC through the TEALS program.",
    "I am a BJC curriculum or tool developer.",
    "I am teaching with the ExCITE project",
    "I am teaching Middle School BJC.",
  ].freeze

  # From an admin perspective, we want to know if a teacher has any **meaningful** change
  # that would require re-reviewing their application.
  before_update :check_for_relevant_changes

  def check_for_relevant_changes
    ignored_fields = %w[created_at updated_at session_count last_session_at ip_history]
    # if any relevant fields have changed
    if (changes.keys - ignored_fields).present?
      handle_relevant_changes
    end
  end

  def handle_relevant_changes
    reset_validation_status
  end

  def reset_validation_status
    return if application_status_changed? || school_id_changed?
    if info_needed?
      not_reviewed!
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_name
    # We need to normalize names for emails.
    "#{full_name} <#{email}>".delete(",")
  end

  def snap_username
    # TODO: use this method until we rename the column.
    self.snap
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

  def self.application_status_options
    Teacher.application_statuses.map { |sym, val| [sym.to_s.titlecase, val] }
  end

  def self.education_level_options
    Teacher.education_levels.map { |sym, val| [sym.to_s.titlecase, val] }
  end

  def self.language_options
    WORLD_LANGUAGES
    #language_codes = ISO3166::Country.all.map { |country| country.languages}.flatten.uniq
  end

  def display_languages
    languages.select { |value| WORLD_LANGUAGES.include?(value)}.join(', ')
  end

  def display_education_level
    if education_level_before_type_cast.to_i == -1
      "?"
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
    application_status.titlecase
  end

  def short_application_status
    {
      validated: "✔️",
      denied: "🚫",
      not_reviewed: "✉️",
      info_needed: "❓",
    }[application_status.to_sym]
  end

  def self.user_from_omniauth(omniauth)
    teachers = Teacher.where("LOWER(email) = :email or LOWER(personal_email) = :email",
      email: omniauth.email.downcase)
    if teachers.length > 1
      raise "Too Many Teachers Found"
    elsif teachers.length == 1
      teachers.first
    else
      nil
    end
  end

  def try_append_ip(ip)
    return if ip_history.include?(ip)
    self.ip_history << ip
    save
  end

  def email_attributes
    # Used when passing data to liquid templates
    {
      teacher_first_name: self.first_name,
      teacher_last_name: self.last_name,
      teacher_full_name: self.full_name,
      teacher_email: self.email,
      teacher_personal_email: self.personal_email,
      teacher_more_info: self.more_info,
      teacher_snap: self.snap_username,
      teacher_snap_username: self.snap_username,
      teacher_education_level: self.education_level,
      teacher_personal_website: self.personal_website,
      teacher_teaching_status: self.text_status,
      teacher_signed_up_at: self.created_at,
      teacher_school_name: self.school.name,
      teacher_school_city: self.school.city,
      teacher_school_state: self.school.state,
      teacher_school_website: self.school.website,
    }
  end

  delegate :name, :location, :grade_level, :website, to: :school, prefix: true
  delegate :school_type, to: :school # don't add a redundant prefix.
  # TODO: The school data needs to be cleaned up.
  def self.csv_export
    attributes = %w|
      id
      full_name
      first_name
      last_name
      email
      personal_email
      snap_username
      education_level
      display_application_status
      text_status
      more_info
      created_at
      session_count
      school_id
      school_name
      school_location
      school_website
      school_grade_level
      school_type
    |

    CSV.generate(headers: true) do |csv|
      csv << attributes

      Teacher.where(admin: false).find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  private
  def ensure_unique_personal_email
    # We want to ensure that both email and personal_email are unique across
    # BOTH columns (i.e. the email only appears once in the combined set)
    # However, it's perfectly valid for personal_email to be nil
    # TODO: This really suggests email needs to be its own table...
    teacher_with_email = Teacher.where.not(id: self.id).exists?(["email = :value OR personal_email = :value", { value: self.email }])
    if teacher_with_email
      errors.add(:email, "must be unique across both email and personal_email columns")
    end
    return unless self.personal_email.present?

    teacher_personal_email = Teacher.where.not(id: self.id).exists?(["email = :value OR personal_email = :value", { value: self.personal_email }])
    if teacher_personal_email
      errors.add(:personal_email, "must be unique across both email and personal_email columns")
    end
  end
end
