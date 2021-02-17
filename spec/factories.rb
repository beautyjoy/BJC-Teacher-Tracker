# This will guess the User class
FactoryBot.define do
  factory :school do
    name { "Basic School" }
    city { "Berkeley"}
    state { "CA" }
    website { "https://www.school.edu" }
  end

  factory :teacher do
    first_name { "Teacher" }
    last_name  { "User" }
    snap { "teacher" }
    email { "teacher@example.edu"}
    status { 0 }
    validated { true }
    personal_website { "https://www.school.edu/teacher" }
    admin { false }

    school
  end

  factory :admin do
    first_name { "Admin" }
    last_name  { "User" }
    email { "admin@berkeley.edu"}
  end
end
