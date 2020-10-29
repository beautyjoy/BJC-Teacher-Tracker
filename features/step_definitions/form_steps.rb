STATUS_FIELD = "What's your current status?"

Given /^I enter my "(.*)" as "(.*)"$/ do |field_name, input|
    fill_in(field_name, with: input)
end

Given /^I set my status as "(.*)"$/ do |input|
    select(input, from: STATUS_FIELD)
end

Then(/I see a confirmation "(.*)"/) do |string|
    page.should have_css ".alert", text: string
end

Then /The "(.*)" field has an error/     do |string|

end

Then /^debug javascript$/ do
    page.driver.debugger
    1
end

Then /^debug$/ do
    require "rubygems"; require "byebug"; byebug
    1 #intentionally force debugger context in this method
end
