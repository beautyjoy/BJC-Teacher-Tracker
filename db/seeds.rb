# frozen_string_literal: true

require_relative "seed_data"

SeedData.emails.each do |email_attrs|
  # to, body fields are updated through development, should not be used as part of the uniqueness check
  email_template = EmailTemplate.find_or_initialize_by(email_attrs.except(:to, :body))
  email_template.update(email_attrs)
end

SeedData.create_schools

SeedData.teachers.each do |teacher|
  Teacher.find_or_create_by(email: teacher[:email]).update(teacher)
end
