When(/^I press "(.*)" button for "(.*)"$/)do |button, slug|
  Capybara.ignore_hidden_elements = false
  elements = page.find('Delete', visible: :all)
  byebug
  page = DynamicPage.find_by(slug: slug)
  find_button(id: page.slug).click
  Capybara.ignore_hidden_elements = true
end
Given(/^I enter (?:my)? "(.*)" as "(.*)"$/) do |field_name, input|
  fill_in(field_name, with: input)
end
