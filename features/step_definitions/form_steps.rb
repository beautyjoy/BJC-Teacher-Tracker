# frozen_string_literal: true

STATUS_FIELD = "What's your current status?"
EDUCATION_FIELD = "What grades to you teach?"

Given(/a valid teacher exists/) do
  school = create(:school)
  create(:teacher, school:)
end

And(/^"(.*)" is not in the database$/) do |email|
  expect(EmailAddress.exists?(email:)).to be false
end

Given(/^I enter (?:my)? "(.*)" as "(.*)"$/) do |field_name, input|
  fill_in(field_name, with: input)
end

Given(/^I set my status as "(.*)"$/) do |input|
  select(input, from: STATUS_FIELD)
end

Given(/^I set my application status as "(.*)"$/) do |input|
  select(input, from: "application_status_select_value")
end

# Locates the selectize widget that wraps the teacher#languages <select>.
# The school selectize on the same form also renders a `.selectize-input`,
# so anchoring to the languages select element by id keeps this stable
# regardless of which widget initializes first.
def languages_selectize
  find("#teacher_languages", visible: :all).find(:xpath, "./following-sibling::div[contains(@class, 'selectize-control')][1]//div[contains(@class, 'selectize-input')]")
end

When(/^I select "(.*?)" from the languages dropdown$/) do |option|
  languages_selectize.click
  find(".selectize-dropdown.active .selectize-dropdown-content .option", text: option).click
end

When(/^I remove "(.*?)" from the languages dropdown$/) do |item|
  languages_selectize.find(".item", text: item).find(".remove").click
end

Then(/^the languages dropdown should have the option "(.*?)" selected$/) do |selected_option|
  expect(languages_selectize.find(".item", text: selected_option)).to be_visible
end

Given(/^I set my request reason as "(.*)"$/) do |input|
  fill_in("request_reason", with: input)
end

Given(/^I select "(.*)" from the skip email notification dropdown$/) do |input|
  select(input, from: "skip_email")
end

Given(/^I set my education level target as "(.*)"$/) do |input|
  select(input, from: EDUCATION_FIELD)
end

When(/^(?:|I )select "([^"]*)" from "([^"]*)" dropdown$/) do |value, readable_field|
  field_mappings = {
    "State" => "state_select"
  }
  field = field_mappings[readable_field] || readable_field
  select_box = find_field(field)
  options = select_box.all("option", text: value)
  if options.length > 1
    options.first.select_option
  else
    select(value, from: field)
  end
end

Then(/I see a confirmation "(.*)"/) do |string|
  page.should have_css ".alert", text: /#{string}/
end

Then(/The "(.*)" form is invalid/) do |id|
  page.evaluate_script("document.querySelector('#{id}').reportValidity()").should be false
end

Then(/^debug javascript$/) do
  page.driver.debugger
  1
end

Then(/^debug$/) do
  require "rubygems"; require "byebug"; byebug
  1 # intentionally force debugger context in this method
end

Then(/the "(.*)" of the user with email "(.*)" should be "(.*)"/) do |field, email, expected|
  email = EmailAddress.find_by(email:)
  expect(email.teacher[field]).to eq(expected)
end

Then(/^I should find a teacher with email "([^"]*)" and school country "([^"]*)" in the database$/) do |email, country|
  teacher = Teacher.joins(:email_addresses, :school)
                   .where(email_addresses: { email: }, schools: { country: })
                   .first
  expect(teacher).not_to be_nil, "No teacher found with email #{email} and country #{country}"
end

When(/^(?:|I )fill in the school name selectize box with "([^"]*)" and choose to add a new school$/) do |text|
  page.execute_script('$("#school_form").show()')
  # Necessary for the Admin School create page
  page.execute_script('$("#submit_button").show()')
  fill_in("School Name", with: text)
end

Then(/^"([^"]*)" click and fill option for "([^"]*)"(?: within "([^"]*)")?$/) do |value|
  find("#school_selectize").click.set(value)
end

When(/^(?:|I )fill in state with "([^"]*)"$/) do |text|
  fill_in("state_textfield", with: text)
end

Then(/^the new teacher form should not be submitted$/) do
  expect(current_path).to eq(new_teacher_path)
  expect(page).to have_content("Your Information")
  expect(page).to have_content("Create a new School")
end
