# frozen_string_literal: true

require_relative "seed_data"

SeedData.emails.each do |email_attrs|
  email_template = EmailTemplate.find_or_initialize_by({ title: email_attrs[:title] })
  email_template.update(email_attrs)
end

SeedData.create_schools

SeedData.teachers.each do |teacher|
  teacher_id = EmailAddress.find_by(email: teacher[:email])&.teacher_id
  # Seed data includes email field for comparison purposes, but it is not part of the Teacher model
  teacher_attrs = teacher.except(:email)
  Teacher.find_or_create_by(id: teacher_id).update(teacher_attrs)
end

SeedData.email_addresses.each do |email_address|
  EmailAddress.find_or_create_by(email: email_address[:email]).update(email_address)
end
