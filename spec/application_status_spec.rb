# require 'test_helper'
# require 'rails_helper'

# describe "admin able to see application status" do
#     fixtures :teachers
#     before(:each) do
#         # Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
#         # Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#         # visit root_path
#         # click_link "/login"
#         # click_button "Sign In"
#         # expect(page).to have_content("BJC Teacher Dashboard")
#         Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#         visit login_path
#     end

#     it "check application status on All Teachers" do
#     # check
#         expect(page).to have_content("BJC Teacher Dashboard")
#     end
#   end
    
