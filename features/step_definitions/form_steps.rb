STATUS_FIELD = "What's your current status?"
EDUCATION_FIELD = "What's your education level target?"

Given /a valid teacher exists/ do
    create(:teacher)
    create(:school)
end

And /^"(.*)" is not in the database$/ do |email|
    expect(Teacher.exists?(email: email)).to be false
end

Given /^I enter (?:my)? "(.*)" as "(.*)"$/ do |field_name, input|
    fill_in(field_name, with: input)
end

Given /^I set my status as "(.*)"$/ do |input|
    select(input, from: STATUS_FIELD)
end

Given /^I set my education level target as "(.*)"$/ do |input|
    select(input, from: EDUCATION_FIELD)
end

Then(/I see a confirmation "(.*)"/) do |string|
    page.should have_css ".alert", text: /#{string}/
end

Then /The "(.*)" form is invalid/ do |id|
    page.evaluate_script("document.querySelector('#{id}').reportValidity()").should be false
end

Then /^debug javascript$/ do
    page.driver.debugger
    1
end

Then /^debug$/ do
    require "rubygems"; require "byebug"; byebug
    1 # intentionally force debugger context in this method
end

Then /the "(.*)" of the user with email "(.*)" should be "(.*)"/ do |field, email, expected|
    expect(Teacher.find_by(email:email)[field]).to eq(expected)
end
