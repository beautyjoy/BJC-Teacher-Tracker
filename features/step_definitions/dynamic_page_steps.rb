# frozen_string_literal: true

When(/^(?:|I )fill in the dynamic_page_body with "([^"]*)"$/) do |value|
  find("trix-editor").click.set(value)
end

When(/^I press the delete button for "(.*)"$/) do |slug|
  click_button("delete_" + slug)
end

When(/^I press the edit button for "(.*)"$/) do |slug|
  click_button("edit_" + slug)
end
