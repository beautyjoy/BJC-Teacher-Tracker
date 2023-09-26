# frozen_string_literal: true

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
