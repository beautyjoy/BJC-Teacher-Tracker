When(/^I press "(.*)" button for "(.*)"$/)do |button, slug|
  Capybara.ignore_hidden_elements = false
  page = DynamicPage.find_by(slug: slug)
  find('td', text: 'Delete',visible:false).click_link('Delete')
  Capybara.ignore_hidden_elements = true
end
Given(/^I enter (?:my)? "(.*)" as "(.*)"$/) do |field_name, input|
  fill_in(field_name, with: input)
end
