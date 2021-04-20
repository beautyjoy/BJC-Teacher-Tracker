require 'cucumber/rspec/doubles'

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
Given /I have a non-admin, unregistered Google email/ do
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

Given /I have a non-admin, unregistered Microsoft email/ do
  OmniAuth.config.mock_auth[:microsoft_graph] = OmniAuth::AuthHash.new({
    provider: 'microsoft_graph',
    uid: '123545',
    info: {
      name: 'Random User',
      first_name: "Random",
      last_name: "User",
      email: "randomemail@microsoft.com",
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
  page.find('button', text: /.*Sign in with Google/).click()
end

Then /I can log in with Microsoft/ do
  allow(Teacher).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:microsoft_graph]
  page.find('button', text: /.*Sign in with Microsoft/).click()
end

And /The TEALS contact email is stubbed/ do
  TeacherMailer::TEALS_CONTACT_EMAIL = 'testcontactemail@berkeley.edu'
end

Then /I can send a deny email/ do
  last_email = ActionMailer::Base.deliveries.last
  last_email.to[0].should eq "testteacher@berkeley.edu"
  last_email.subject.should eq "Deny Email"
  last_email.body.encoded.should include "Denial Reason"
end
