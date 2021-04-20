require_relative 'seed_data'

Teacher.where(admin: true).destroy_all
EmailTemplate.destroy_all

SeedData.emails.each {|email| EmailTemplate.find_or_create_by(email)}
SeedData.teachers.each {|teacher| Teacher.find_or_create_by(teacher)}
