# frozen_string_literal: true

# == Schema Information
#
# Table name: email_addresses
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  primary    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  teacher_id :bigint           not null
#
# Indexes
#
#  index_email_addresses_on_email                   (email) UNIQUE
#  index_email_addresses_on_teacher_id              (teacher_id)
#  index_email_addresses_on_teacher_id_and_primary  (teacher_id,primary) UNIQUE WHERE ("primary" = true)
#
# Foreign Keys
#
#  fk_rails_...  (teacher_id => teachers.id)
#
class EmailAddress < ApplicationRecord
  belongs_to :teacher

  # Regular expression for validating the format of an email address
  # https://stackoverflow.com/a/7791100/23305580
  EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/


  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validate :only_one_primary_email_per_teacher

  before_save :downcase_email
  before_save :flag_teacher_if_email_changed

  private
  def only_one_primary_email_per_teacher
    if primary? && EmailAddress.where(teacher_id:, primary: true).where.not(id:).exists?
      errors.add(:primary, "There can only be one primary email per teacher.")
    end
  end

  def downcase_email
    self.email = email.downcase
  end

  def flag_teacher_if_email_changed
    if self.email_changed? && !self.new_record?
      teacher.email_changed_flag = true
      teacher.handle_relevant_changes
    end
  end
end
