# This will guess the User class
FactoryBot.define do
  factory :teacher do
    first_name { "Teacher" }
    last_name  { "User" }
    snap { "teacher" }
    email { "teacher@teacher.k12.org"}
    status { 0 }
    personal_website { "https://www.school.edu/teacher" }
    admin { false }
  end
end
