# frozen_string_literal: true

require "rails_helper"
require "csv_process"

RSpec.describe CsvProcess do
  fixtures :all

  # CsvProcess is a controller concern; `flash` is only needed by add_flash_message.
  let(:importer) { Class.new { include CsvProcess }.new }
  let(:school) { schools(:berkeley) }

  def base_row(overrides = {})
    { first_name: "New", last_name: "Teacher", status: 0,
      personal_website: "https://example.com", school_id: school.id }.merge(overrides)
  end

  it "rejects a row with no email instead of matching an arbitrary teacher" do
    existing = teachers(:reimu)
    before_attrs = existing.slice(:first_name, :last_name, :school_id, :status)

    result = importer.process_record([base_row(first_name: "Pwned", last_name: "ByImport")])

    expect(result[:success_count]).to eq(0)
    expect(result[:fail_count]).to eq(1)
    expect(existing.reload.slice(:first_name, :last_name, :school_id, :status)).to eq(before_attrs)
  end

  it "creates a teacher with a usable primary EmailAddress" do
    result = importer.process_record([base_row(email: "brand.new@example.com")])

    expect(result[:success_count]).to eq(1)
    teacher = EmailAddress.find_by(email: "brand.new@example.com").teacher
    expect(teacher.primary_email).to eq("brand.new@example.com")
    # user_from_omniauth resolves logins through EmailAddress.
    expect(Teacher.user_from_omniauth(OpenStruct.new(email: "brand.new@example.com"))).to eq(teacher)
  end

  it "updates the existing teacher matched by their EmailAddress rather than duplicating" do
    existing = teachers(:reimu)

    expect {
      importer.process_record([base_row(email: existing.primary_email, first_name: "Renamed")])
    }.not_to change(Teacher, :count)

    expect(existing.reload.first_name).to eq("Renamed")
  end

  it "matches case-insensitively and ignores surrounding whitespace" do
    existing = teachers(:reimu)

    expect {
      importer.process_record([base_row(email: "  #{existing.primary_email.upcase}  ", first_name: "Trimmed")])
    }.not_to change(Teacher, :count)

    expect(existing.reload.first_name).to eq("Trimmed")
  end

  it "fails the row when the school_id is invalid" do
    result = importer.process_record([base_row(email: "nope@example.com", school_id: 999_999_999)])

    expect(result[:fail_count]).to eq(1)
    expect(result[:failed_emails]).to eq(["nope@example.com"])
    expect(EmailAddress.find_by(email: "nope@example.com")).to be_nil
  end

  it "creates a school by name and links the teacher to it" do
    row = { first_name: "New", last_name: "Teacher", status: 0,
            personal_website: "https://example.com", email: "with.school@example.com",
            school_name: "Brand New High", school_city: "Oakland", school_state: "CA",
            school_website: "https://bnh.example.com", school_grade_level: 2, school_type: 0 }

    result = importer.process_record([row])

    expect(result[:school_count]).to eq(1)
    expect(result[:success_count]).to eq(1)
    teacher = EmailAddress.find_by(email: "with.school@example.com").teacher
    expect(teacher.school.name).to eq("Brand New High")
    # counter_cache owns teachers_count; it must not be hardcoded.
    expect(teacher.school.reload.teachers_count).to eq(1)
  end

  it "reuses an existing school matched by name" do
    row = { first_name: "New", last_name: "Teacher", status: 0,
            personal_website: "https://example.com", email: "reuse@example.com",
            school_name: school.name }

    expect { importer.process_record([row]) }.not_to change(School, :count)

    expect(EmailAddress.find_by(email: "reuse@example.com").teacher.school).to eq(school)
  end
end
