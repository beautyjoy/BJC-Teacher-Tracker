# frozen_string_literal: true

When(/^I press the delete button for "(.*)"$/) do |slug|
  Capybara.ignore_hidden_elements = false
  # button = find_button(id: slug)
  # click_button(button)
  # Capybara.ignore_hidden_elements = true
  # find('#delete_'+slug).click
  # click_link_or_button(id: slug)
  find("table").find("tbody").find("tr",id:"Row."+slug).find("Delete."+slug).click
end

When(/^(?:|I )fill in the dynamic_page_body with "([^"]*)"$/) do |value|
  find('trix-editor').click.set(value)
end
