# frozen_string_literal: true

require "cucumber/rspec/doubles"

# Returns a OAuth2 token associated with email "testteacher@berkeley.edu"
Given(/I have a teacher (.*) email/) do |login|
  service = LOGIN_SERVICE[login]
  OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
    provider: service,
    uid: "123545",
    info: {
      name: "Joseph",
      first_name: "Joseph",
      last_name: "Mamoa",
      email: "testteacher@berkeley.edu",
      school: "UC Berkeley",
    },
    credentials: {
      token: "test_token",
      refresh_token: "test_refresh_token"
    }
  })
end

Given(/the following schools exist/) do |schools_table|
  schools_default = {
    name: "UC Berkeley",
    city: "Berkeley",
    state: "CA",
    website: "https://www.berkeley.edu"
  }
  schools_table.hashes.each do |school|
    schools_default.each do |key, value|
      school[key] = value if school[key].nil?
    end
    School.create!(school)
  end
end

Given(/the following teachers exist/) do |teachers_table|
  teachers_default = {
    first_name: "Alonzo",
    last_name: "Church",
    email: "alonzo@snap.berkeley.edu",
    snap: "",
    status: "Other - Please specify below.",
    education_level: 1,
    more_info: "I'm teaching a college course",
    admin: false,
    personal_website: "https://snap.berkeley.edu",
    application_status: "Pending"
  }

  teachers_table.hashes.each do |teacher|
    teachers_default.each do |key, value|
      teacher[key] = teacher[key].presence || value
    end

    # Extract extra parameter 'school'
    school_name = teacher.delete("school")
    new_teacher = Teacher.create(teacher)

    # Create an association between teacher and school
    school = School.find_by(name: school_name || "UC Berkeley")
    new_teacher.school = school
    new_teacher.save!
  end
end

Then(/there is a TEALS email/) do
  last_email = ActionMailer::Base.deliveries.last
  last_email.subject.should eq "TEALS Confirmation Email"
  last_email.to[0].should eq "testcontactemail@berkeley.edu"
  last_email.body.encoded.should include "Joe Mamoa"
end
