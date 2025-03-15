# frozen_string_literal: true

FactoryBot.define do
  factory :school do
    name { "Basic School" }
    country { "US" }
    city { "Berkeley" }
    state { "CA" }
    grade_level { 4 }
    school_type { 0 }
    website { "https://www.school.edu" }
  end
end
