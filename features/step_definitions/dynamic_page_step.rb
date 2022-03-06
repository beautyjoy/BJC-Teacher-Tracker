When(/^(?:|I )press "(.*)" button for "(.*)"$/)do |button, slug|
  page = DynamicPage.find_by(slug: slug)
  find_button(button,page.id).click
end
