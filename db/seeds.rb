# frozen_string_literal: true

require_relative "seed_data"

EmailTemplate.delete_all
SeedData.emails.each { |email| EmailTemplate.create!(email) }

SeedData.create_schools

SeedData.teachers.each do |teacher|
  Teacher.find_or_create_by(email: teacher[:email]).update(teacher)
end
