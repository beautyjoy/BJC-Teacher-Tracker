# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :school do
    name { "Basic School" }
    city { "Berkeley" }
    state { "CA" }
    website { "https://www.school.edu" }
  end

  factory :teacher do
    first_name { "Teacher" }
    last_name  { "User" }
    snap { "teacher" }
    email { "teacher@example.edu" }
    status { 0 }
    application_status { "Validated" }
    personal_website { "https://www.school.edu/teacher" }
    admin { false }
  end

  factory :admin do
    first_name { "Admin" }
    last_name  { "User" }
    email { "admin@berkeley.edu" }
  end
end
