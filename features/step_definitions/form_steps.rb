Given /^I enter my "(.*)" as "(.*)"$/ do |field_name, input|
    fill_in(field_name, with: input)
end
  
Then("I see a confirmation {string}") do |string|
    page.should have_content "Thanks for signing up!"   
end