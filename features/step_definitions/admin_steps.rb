require 'cucumber/rspec/doubles'

# Prereq: In order for admin capability, "testadminuser@berkeley.edu" must exist within ENV["TEST_ADMIN_EMAILS"]
# Returns a OAuth2 token associated with email "testadminuser@berkeley.edu"
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

# Returns a OAuth2 token associated with email "randomemail@gmail.com"
Given /I have a random email/ do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123545',
    info: {
      name: 'Random User',
      first_name: "Random",
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
  page.find('button', text: /.*Log In/).click()
end
