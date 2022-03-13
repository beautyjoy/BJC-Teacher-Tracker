When(/^I press "(.*)" button for "(.*)"$/)do |button, slug|
  Capybara.ignore_hidden_elements = false
  page = DynamicPage.find_by(slug: slug)
  find_button(id: page.slug).click
  Capybara.ignore_hidden_elements = true
end
