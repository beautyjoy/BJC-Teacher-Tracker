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
FactoryBot.define do
  factory :teacher do
    first_name { "Teacher" }
    last_name  { "User" }
    snap { "teacher" }
    sequence(:email) { |n| "teacher-#{n}@example.edu" }
    status { 0 }
    application_status { "Validated" }
    personal_website { "https://www.school.edu/teacher" }
    admin { false }
  end
end
