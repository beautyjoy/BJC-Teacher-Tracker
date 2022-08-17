# frozen_string_literal: true

Given(/the following pages exist/) do |pages_table|
  default_params = {
    slug: "test_slug",
    title: "Test Page Title",
    html: "Test page body.",
    permissions: "Public",
    creator_id: Teacher.first.id,
    last_editor: Teacher.first
  }

  pages_table.symbolic_hashes.each do |page|
    Page.create!(default_params.merge(page))
  end
end

When(/^(?:|I )fill in the page HTML content with "([^"]*)"$/) do |value|
  find_field("HTML Content").set(value)
end

When(/^I press the delete button for "(.*)"$/) do |slug|
  click_button("delete_" + slug)
end

When(/^I press the edit button for "(.*)"$/) do |slug|
  click_button("edit_" + slug)
end

Then(/^The radio button "(.*)" should be checked$/) do |radio_button_name|
  expect(find_field(radio_button_name)).to be_checked
end

And(/^I should see a(n active)? nav link "(.*)"/) do |active, link_text|
  expect(page).to have_css("a.nav-link", text: link_text)
end

And(/^And I use the sidebar link "(.*)"/) do |link_text|
  click_link(".nav-link", text: link_text)
end
