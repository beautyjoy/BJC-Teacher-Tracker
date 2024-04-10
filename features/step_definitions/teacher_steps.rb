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
    email: "alonzo@snap.berkeley.edu",
    snap: "",
    status: "Other - Please specify below.",
    education_level: 1,
    more_info: "",
    admin: false,
    personal_website: "https://snap.berkeley.edu",
    application_status: "Not Reviewed",
    languages: ["English"],
    session_count: 1,
    last_session_at: DateTime.now,
    ip_history: [IPAddr.new("1.2.3.4")]
  }

  teachers_table.symbolic_hashes.each do |teacher|
    teachers_default.each do |key, value|
      # Parse the 'languages' field as an array of strings using YAML.safe_load
      if key == :languages
        languages = if teacher[key].present? then YAML.safe_load(teacher[key]) else nil end
        teacher[key] = languages.presence || value
      elsif key == :last_session_at
        #conversion to DateTime object needed
        teacher[key] = if teacher[key].present? then DateTime.parse(teacher[key]) else value end
      elsif key == :session_count
        #type cast from string --> int needed
        teacher[key] = (teacher[key].presence || value).to_i
      elsif key == :ip_history
        #type cast from comma-separated list of ip addresses to array of IPAddr objects
        ip_addr_array = if teacher[key].present? then teacher[key].split(/\s*,\s*/).map { |ip_str| IPAddr.new(ip_str.strip) } else nil end
        teacher[key] = ip_addr_array.presence || value
      else
        # Handle other fields as usual
        teacher[key] = teacher[key].presence || value
      end
    end

    school_name = teacher.delete(:school)
    school = School.find_by(name: school_name || "UC Berkeley")
    teacher[:school_id] = school.id
    Teacher.create!(teacher)
    School.reset_counters(school.id, :teachers)
  end
end

Then(/the following entries should exist in the teachers database/) do |entries_table|
  entries_table.symbolic_hashes.each do |teacher_params|
    school_name = teacher_params[:school]
    teacher_params.delete(:school)
    #teacher should be present and school should be valid
    expect(!Teacher.find_by(teacher_params).blank?).to be true
    expect(!(School.find_by(name: school_name).blank?)).to be true
  end 
end

Then(/the following entries should not exist in the teachers database/) do |entries_table|
  entries_table.symbolic_hashes.each do |teacher_params|
    teacher_params.delete(:school)
    #matches on all fields except school name
    expect(Teacher.find_by(teacher_params).blank?).to be true
  end 
end
