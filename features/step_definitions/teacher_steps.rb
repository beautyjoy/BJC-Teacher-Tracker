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
      primary_email: "testteacher@berkeley.edu",
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
    name: "UC Berkeley - New",
    city: "Berkeley",
    state: "CA",
    website: "https://www.berkeley.edu",
    grade_level: "university",
    school_type: "public",
    tags: [],
    nces_id: 123456789100
  }
  schools_table.symbolic_hashes.each do |school|
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
    snap: "",
    status: "Other - Please specify below.",
    education_level: 1,
    more_info: "I'm teaching a college course",
    admin: false,
    personal_website: "https://snap.berkeley.edu",
    application_status: "Not Reviewed",
    languages: ["English"],

    # Note: primary email field does not exist in the new schema of the Teacher model
    # Include it in the seed data is to simulate the behavior of creating a new teacher,
    # because we need to use it to compared with the EmailAddress model,
    # to determine the existence of the teacher
    primary_email: "alonzo@snap.berkeley.edu",
  }

  teachers_table.symbolic_hashes.each do |teacher|
    teachers_default.each do |key, value|
      # Parse the 'languages' field as an array of strings using YAML.safe_load
      if key == :languages
        languages = if teacher[key].present? then YAML.safe_load(teacher[key]) else nil end
        teacher[key] = languages.presence || value
      else
        # Handle other fields as usual
        teacher[key] = teacher[key].presence || value
      end
    end

    email = teacher.delete(:primary_email)

    school_name = teacher.delete(:school)
    school = School.find_by(name: school_name || "UC Berkeley")
    teacher[:school_id] = school.id
    teacher = Teacher.create!(teacher)
    EmailAddress.create!(email:, teacher:, primary: true)
    School.reset_counters(school.id, :teachers)
  end
end
