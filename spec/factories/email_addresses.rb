# frozen_string_literal: true

FactoryBot.define do
  factory :email_address do
    association :teacher
    sequence(:email) { |n| "teacher-#{n}@example.edu" }
    primary { false }
  end
end
