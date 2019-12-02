Given /^I enter my "(.*)" as "(.*)"$/ do |field_name, input|
    fill_in(field_name, with: input)
end
  
Then("I see a confirmation {string}") do |string|
    page.should have_content "Thanks for signing up!"   
end
  
Given("I don't enter my information in all the provided fields") do
   #don't fill out

end
  
Then("I should see an empty form on the home page") do
    pending # Write code here that turns the phrase above into concrete actions
end


Given /the following movies exist/ do |movies_table|
    movies_table.hashes.each do |movie|
      Movie.create movie
    end
  end
  
  Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
    #  ensure that that e1 occurs before e2.
    #  page.body is the entire content of the page as a string.
    expect(page.body.index(e1) < page.body.index(e2))
  end
  
  When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.split(', ').each do |rating|
      step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
    end
  end
  
  Then /I should see all the movies/ do
    # Make sure that all the movies in the app are visible in the table
    Movie.all.each do |movie|
      step %{I should see "#{movie.title}"}
    end
  end
  
  Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |movie_arg, director_arg|
    movie = Movie.find_by_title(movie_arg)
    expect(movie.director).to eq director_arg
  
    #page.should have_content(movie)
    #page.should have_content(director)
  end