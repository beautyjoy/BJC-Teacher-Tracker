# frozen_string_literal: true

# == Schema Information
#
# Table name: pd_registrations
#
#  id                          :bigint           not null, primary key
#  attended                    :boolean          default(FALSE)
#  role                        :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  professional_development_id :integer          not null
#  teacher_id                  :integer          not null
#
# Indexes
#
#  index_pd_reg_on_teacher_id_and_pd_id  (teacher_id,professional_development_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (professional_development_id => professional_developments.id)
#  fk_rails_...  (teacher_id => teachers.id)
#
class PdRegistration < ApplicationRecord
  belongs_to :teacher
  belongs_to :professional_development

  validates :teacher_id, uniqueness: { scope: :professional_development_id, message: "already has a registration for this PD" }
  validates :role, inclusion: { in: %w[leader attendee], message: "%{value} is not a valid role" }
  validates :attended, inclusion: { in: [true, false] }

  validate :professional_development_dates_passed, on: :create

  def teacher_name
    teacher = Teacher.find_by(id: teacher_id)
    if teacher.present?
      "#{teacher.first_name} #{teacher.last_name}"
    else
      "Teacher not found"
    end
  end

  private
  def professional_development_dates_passed
    return unless professional_development&.end_date&.past?

    errors.add(:professional_development_id, "can't register for past events")
  end
end
