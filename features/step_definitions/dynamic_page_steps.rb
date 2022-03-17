# frozen_string_literal: true

Given(/the following dynamic pages exist/) do |dynamic_pages_table|
  dynamic_pages_default = {
    slug: "test_slug",
    title: "Test Page Title",
    body: "Test page body.",
    permissions: "Public",
    creator_id: Teacher.all[0].id,
    last_editor: Teacher.all[0].id
  }
  dynamic_pages_table.symbolic_hashes.each do |dynamic_page|
    dynamic_pages_default.each do |key, value|
      dynamic_page[key] = value if dynamic_page[key].nil?
    end
    DynamicPage.create!(dynamic_page)
  end
end

When(/^(?:|I )fill in the dynamic_page_body with "([^"]*)"$/) do |value|
  find("trix-editor").click.set(value)
end

When(/^I press the delete button for "(.*)"$/) do |slug|
  click_button("delete_" + slug)
end

When(/^I press the edit button for "(.*)"$/) do |slug|
  click_button("edit_" + slug)
end
