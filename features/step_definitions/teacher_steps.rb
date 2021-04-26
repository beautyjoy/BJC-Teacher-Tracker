require 'cucumber/rspec/doubles'

# Returns a OAuth2 token associated with email "testteacher@berkeley.edu"
Given /I have a teacher Google email/ do
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

# Returns a OAuth2 token associated with email "testteacher@berkeley.edu"
Given /I have a teacher Microsoft email/ do
  OmniAuth.config.mock_auth[:microsoft_graph] = OmniAuth::AuthHash.new({
    provider: 'microsoft_graph',
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

# Returns a OAuth2 token associated with email "testteacher@berkeley.edu"
Given /I have a teacher Clever email/ do
  OmniAuth.config.mock_auth[:clever] = OmniAuth::AuthHash.new({
    provider: 'clever',
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
  teachers_default = {
    first_name: "Alonzo",
    last_name: "Church",
    email: "alonzo@snap.berkeley.edu",
    snap: '',
    status: "Other - Please specify below.",
    education_level: 1,
    more_info: "I'm teaching a college course",
    admin: false,
    personal_website: "https://snap.berkeley.edu",
    application_status: "Pending"
  }

  teachers_table.hashes.each do |teacher|
    teachers_default.each do |key, value|
      if teacher[key] == nil
        teacher[key] = value
      end
    end

    # Extract extra parameter 'school'
    school_name = teacher.delete("school")

    new_teacher = Teacher.create!(teacher)

    #Create an association between teacher and school
    if school_name != nil
      school = School.find_by(name: school_name)
      if school != nil
        new_teacher.school = school
        new_teacher.save!
      end
    end
  end
end

Then /there is a TEALS email/ do
  last_email = ActionMailer::Base.deliveries.last
  last_email.subject.should eq "TEALS Confirmation Email"
  last_email.to[0].should eq "testcontactemail@berkeley.edu"
  last_email.body.encoded.should include "Joe Mamoa"
end
