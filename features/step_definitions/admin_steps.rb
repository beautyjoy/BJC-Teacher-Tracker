require 'cucumber/rspec/doubles'

Given /I am an admin user/ do
  visit root_url
end

# A wrapper around the omniauth link.
# TODO: This should be adapted to take in a provider.
Then /I can log in with Google as Admin/ do
  allow(Teacher).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_admin]
  page.find('button', text: /.*Sign in/).click()
end

#Combine with the previous method if this works fine -- Steven 2/23
Then /I can log in with Google as Teacher/ do
  allow(Teacher).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_teacher]
  page.find('button', text: /.*Sign in/).click()
end

Given(/the following teachers exist/) do |teachers_table|
  #Default Values
  teachers_default = {first_name: "Alonzo", last_name: "Church", email: "alonzo@snap.berkeley.edu", course: "https://school.edu", snap: "alonzo", 
                      other: "I'm teaching a college course", validated: false, status: "Other - Please specify below.", 
                      more_info: "I'm teaching a college course", admin: false, personal_website: "https://snap.berkeley.edu", denied: false}
  
  teachers_table.hashes.each do |teacher|
    teachers_default.each do |key, value|
      if teacher[key] == nil
        teacher[key] = value
      end
    end
    Teacher.create!(teacher)
  end
end
