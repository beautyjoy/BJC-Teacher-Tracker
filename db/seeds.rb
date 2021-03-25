require_relative 'seed_data'

EmailTemplate.destroy_all

SeedData.emails.each {|email| EmailTemplate.find_or_create_by(email)}
