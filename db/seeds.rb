require_relative 'seed_data'

SeedData.emails.each { |email| EmailTemplate.find_or_create_by(email) }

SeedData.teachers.each { |teacher| Teacher.find_or_create_by(teacher) }
