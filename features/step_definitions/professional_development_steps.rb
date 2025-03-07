# frozen_string_literal: true

require "cucumber/rspec/doubles"

Given(/the following professional developments exist/) do |professional_developments_table|
  professional_developments_table.symbolic_hashes.each do |development|
    ProfessionalDevelopment.create!(development)
  end
end

Given(/the following professional developments registrations exist/) do |pd_registrations_table|
  pd_registrations_table.symbolic_hashes.each do |registration_hash|
    development = ProfessionalDevelopment.find_by(id: registration_hash[:professional_development_id])
    raise "ProfessionalDevelopment not found: #{registration_hash[:professional_development_name]}" unless development
    registration_details = registration_hash.merge(professional_development: development)
    PdRegistration.create!(registration_details)
  end
end

Then(/^I should arrive at the professional development show page titled "([^"]*)"$/) do |title|
  development = ProfessionalDevelopment.find_by(name: title)
  expect(current_path).to eq(professional_development_path(development))
end

Then(/^I visit the professional development show page titled "([^"]*)"$/) do |title|
  development = ProfessionalDevelopment.find_by(name: title)
  visit(professional_development_path(development))
end
