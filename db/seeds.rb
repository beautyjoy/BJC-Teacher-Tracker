# frozen_string_literal: true

require_relative "seed_data"

SeedData.emails.each { |email| EmailTemplate.find_or_create_by(email) }

SeedData.teachers.each do |teacher|
  Teacher.find_or_create_by(email: teacher[:email]).update_attributes(teacher)
end
