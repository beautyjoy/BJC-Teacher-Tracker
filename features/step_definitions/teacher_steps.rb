require 'cucumber/rspec/doubles'

Given /I have a teacher email/ do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123545',
    info: {
      name: 'Joseph',
      first_name: "Joseph",
      last_name: "Mamoa",
      email: "testteacher@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: 'test_token'
    }
  })
end


Given(/the following schools exist/) do |schools_table|
  schools_default = {name: "UC Berkeley", city: "Berkeley", state: "CA", website: "https://www.berkeley.edu"}
  schools_table.hashes.each do |school|
    schools_default.each do |key, value|
      if school[key] == nil
        school[key] = value
      end
    end
    School.create!(school)
  end
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

