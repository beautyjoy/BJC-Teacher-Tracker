# frozen_string_literal: true

require "cucumber/rspec/doubles"

Given(/the following emails exist/) do |emails_table|
  emails_table.symbolic_hashes.each do |email_hash|
    teacher = Teacher.find_by(first_name: email_hash[:first_name], last_name: email_hash[:last_name])
    raise "Teacher not found for email: #{email_hash[:email]}" unless teacher

    EmailAddress.create!(
      email: email_hash[:email],
      teacher:,
      primary: email_hash[:primary] == "true"
    )
  end
end

When(/^I press "([^"]*)" next to "([^"]*)"$/) do |button_text, email_text|
  email_field = all('.email-field').find { |field| field.has_css?('input[type="email"][value="' + email_text + '"]') }
  within(email_field) do
    click_link(button_text)
  end
end
