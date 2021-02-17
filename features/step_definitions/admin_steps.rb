require 'cucumber/rspec/doubles'

Given /I am an admin user/ do
  visit root_url
end

# A wrapper around the omniauth link.
# TODO: This should be adapted to take in a provider.
Then /I can log in with Google/ do
  allow(Admin).to receive(:validate_auth).and_return(true)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  page.find('button', text: /.*Sign in/).click()
end
