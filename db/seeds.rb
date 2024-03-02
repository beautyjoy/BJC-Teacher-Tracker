# frozen_string_literal: true

require_relative "seed_data"

SeedData.emails.each do |email_attrs|
  # Based on what Professor Ball mentioned, 'title' is the unique identifier for each EmailTemplate
  unique_identifier = { title: email_attrs[:title] }
  email_template = EmailTemplate.find_or_initialize_by(unique_identifier)
  email_template.update(email_attrs)
end

SeedData.create_schools

SeedData.teachers.each do |teacher|
  Teacher.find_or_create_by(email: teacher[:email]).update(teacher)
end
