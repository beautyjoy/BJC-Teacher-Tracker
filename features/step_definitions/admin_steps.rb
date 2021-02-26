require 'cucumber/rspec/doubles'

Given /I have an admin email/ do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123545',
    info: {
      name: 'Admin User',
      first_name: "Admin",
      last_name: "User",
      email: "testadminuser@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: 'test_token'
    }
  })
end

Given /I have a teacher email/ do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123545',
    info: {
      name: 'Admin User',
      first_name: "Admin",
      last_name: "User",
      email: "testteacher@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: 'test_token'
    }
  })
end

Given /I have a random email/ do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123545',
    info: {
      name: 'Admin User',
      first_name: "Admin",
      last_name: "User",
      email: "randomemail@gmail.com",
      school: "UC Berkeley",
    },
    credentials: {
      token: 'test_token'
    }
  })
end


# A wrapper around the omniauth link.
# TODO: This should be adapted to take in a provider.
Then /I can log in with Google/ do
  allow(Teacher).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
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
