# frozen_string_literal: true

When(/^I press the delete button for "(.*)"$/) do |slug|
  Capybara.ignore_hidden_elements = false
  # button = find_button(id: slug)
  # click_button(button)
  # Capybara.ignore_hidden_elements = true
  # find(slug).click
  # click_link_or_button(id: slug)
  find("td",{text:"Delete",id:slug}).click
end

When(/^(?:|I )fill in the dynamic_page_body with "([^"]*)"$/) do |value|
  find('trix-editor').click.set(value)
end
