# frozen_string_literal: true

require "cucumber/rspec/doubles"

LOGIN_SERVICE = {
  Google: :google_oauth2,
  Microsoft: :microsoft_graph,
  Snap: :discourse,
  Clever: :clever
}.with_indifferent_access

# Returns a OAuth2 token associated with email "testadminuser@berkeley.edu"
Given(/I have an admin email/) do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: "123545",
    info: {
      name: "Admin User",
      first_name: "Admin",
      last_name: "User",
      email: "testadminuser@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: "test_token",
      refresh_token: "test_refresh_token"
    }
  })
end

# Returns a OAuth2 token associated with email "randomemail@gmail.com"
Given(/I have a non-admin, unregistered (.*) email/) do |login|
  service = LOGIN_SERVICE[login]
  OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
    provider: service,
    uid: "123545",
    info: {
      name: "Random User",
      first_name: "Random",
      last_name: "User",
      email: "randomemail@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: "test_token",
      refresh_token: "test_refresh_token"
    }
  })
end

# A wrapper around the omniauth link.
Then(/I can log in with (.*)/) do |login|
  service = LOGIN_SERVICE[login]
  allow(Teacher).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[service]
  page.find("button", text: /.*Sign in with #{login}/).click()
end

Then(/I cannot log in with Google/) do
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  page.find("button", text: /.*Sign in with Google/).click()
end

And(/The TEALS contact email is stubbed/) do
  TeacherMailer::TEALS_CONTACT_EMAIL = "testcontactemail@berkeley.edu"
end

Then(/I can send a deny email/) do
  last_email = ActionMailer::Base.deliveries.last
  last_email.to[0].should eq "testteacher@berkeley.edu"
  last_email.subject.should eq "Deny Email"
  last_email.body.encoded.should include "Denial Reason"
end

Then(/I attach the csv "([^"]*)"$/) do |path|
  Capybara.ignore_hidden_elements = false
  attach_file("file", File.expand_path(path))
  Capybara.ignore_hidden_elements = true
end
