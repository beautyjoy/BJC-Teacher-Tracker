require_relative 'seed_data'

Teacher.destroy_all

SeedData.teachers.each {|teacher| Teacher.create!(teacher)}