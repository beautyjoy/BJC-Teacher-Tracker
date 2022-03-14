When(/^I press "(.*)" button for "(.*)"$/)do |button, slug|
  Capybara.ignore_hidden_elements = false
  page = DynamicPage.find_by(slug: slug)
  find(button,{id: slug,text:"Delete"}).click
  #find_button(button, id: slug).click
  Capybara.ignore_hidden_elements = true
end
