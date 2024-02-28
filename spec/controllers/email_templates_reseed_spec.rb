# frozen_string_literal: true

require "rails_helper"

# This test suite verifies the reseeding behavior of EmailTemplate models to ensure
# that email templates are correctly handled (i.e., updated or removed) without duplication
# upon reseeding the database with new seed data. It tests the initial seeding, updates to
# templates, and the removal of templates that are no longer present in the seed data.
RSpec.describe "EmailTemplate Reseed Behavior", type: :model do
  # To ensure that the tests run against the correct database.
  include_context "database verification"
  # Define email content for initial seeding and subsequent updates. These blocks
  # provide a flexible way to manage test data, allowing us to simulate changes in seed data
  # across different test scenarios.
  let(:form_submission_old) do
    <<-FORM_SUBMISSION
      <p>Submitted Information:</p>
      <p>I am the original content of the form submission email.</p>
    FORM_SUBMISSION
  end

  let(:request_info_email_old) do
    <<-REQUEST_INFO_EMAIL
      <p>Dear {{teacher_first_name}},</p>
      <p>I am the original content of the request info email.</p>
    REQUEST_INFO_EMAIL
  end

  let(:request_info_email_new) do
    <<-REQUEST_INFO_EMAIL
    <p>Dear {{teacher_first_name}},</p>
    <p>I am NEW Template Content of the request info email.</p>
    REQUEST_INFO_EMAIL
  end

  # Setup phase: Mocks the SeedData.emails call to return predetermined email content.
  # This mimics the initial seeding process with specific email templates before each test.
  before do
    # Clean the database for email templates before each test.
    # This is safe to do due to the `database verification` context
    EmailTemplate.delete_all
    allow(SeedData).to receive(:emails).and_return(
      [
        {
          to: "lmock@berkeley.edu, contact@bjc.berkeley.edu",
          body: form_submission_old,
          path: "teacher_mailer/form_submission",
          locale: nil,
          handler: "liquid",
          partial: false,
          format: "html",
          title: "Form Submission",
          required: true,
          subject: "Form Submission"
        },
        {
          body: request_info_email_old,
          to: "{{teacher_email}}, {{teacher_personal_email}}",
          path: "teacher_mailer/request_info_email",
          locale: nil,
          handler: "liquid",
          partial: false,
          format: "html",
          title: "Request Info Email",
          required: true,
          subject: "Request Info Email"
        }
      ])
    # Simulates the seeding action.
    load Rails.root.join("db/seeds.rb")

    # Verify original content
    expect(EmailTemplate.count).to eq(2)
    request_info_email = EmailTemplate.find_by(title: "Request Info Email")
    expect(request_info_email).to be_present
    expect(request_info_email.title).to eq("Request Info Email")
    expect(request_info_email.body).to include("I am the original content of the request info email")

    form_submission_email = EmailTemplate.find_by(title: "Form Submission")
    expect(form_submission_email).to be_present
    expect(form_submission_email.title).to eq("Form Submission")
    expect(form_submission_email.body).to include("I am the original content of the form submission email")
  end

  it "does not duplicate email templates on reseed with updated content" do
    # Mock the SeedData.emails call to return updated email content for the "Request Info Email" template.
    # This simulates the reseeding process with updated email content.
    allow(SeedData).to receive(:emails).and_return(
      [
        {
          to: "lmock@berkeley.edu, contact@bjc.berkeley.edu",
          body: form_submission_old,
          path: "teacher_mailer/form_submission",
          locale: nil,
          handler: "liquid",
          partial: false,
          format: "html",
          title: "Form Submission",
          required: true,
          subject: "Form Submission"
        },
        {
          body: request_info_email_new,
          to: "{{teacher_email}}, {{teacher_personal_email}}",
          path: "teacher_mailer/request_info_email",
          locale: nil,
          handler: "liquid",
          partial: false,
          format: "html",
          title: "Request Info Email",
          required: true,
          subject: "Request Info Email"
        }
      ])
    load Rails.root.join("db/seeds.rb")

    # Verify updated content: Email count is still 2, with only updated content for the request info email.
    expect(EmailTemplate.count).to eq(2)
    request_info_email = EmailTemplate.find_by(title: "Request Info Email")
    expect(request_info_email).to be_present
    expect(request_info_email.title).to eq("Request Info Email")
    expect(request_info_email.body).to include("I am NEW Template Content of the request info email")

    form_submission_email = EmailTemplate.find_by(title: "Form Submission")
    expect(form_submission_email).to be_present
    expect(form_submission_email.title).to eq("Form Submission")
    expect(form_submission_email.body).to include("I am the original content of the form submission email")
  end

  it "removes email templates not present in updated seed data" do
    # Mock the SeedData.emails call to only return the "Request Info Email" template,
    # simulating the removal of the "Form Submission" template from the seed data.
    allow(SeedData).to receive(:emails).and_return(
      [
        {
          body: request_info_email_old,
          to: "{{teacher_email}}, {{teacher_personal_email}}",
          path: "teacher_mailer/request_info_email",
          locale: nil,
          handler: "liquid",
          partial: false,
          format: "html",
          title: "Request Info Email",
          required: true,
          subject: "Request Info Email"
        }
      ])
    load Rails.root.join("db/seeds.rb")

    # Verify that the "Form Submission" email template is removed
    expect(EmailTemplate.count).to eq(1)
    expect(EmailTemplate.find_by(title: "Form Submission")).to be_nil

    # Additionally, verify that the "Request Info Email" template remains and is unchanged
    request_info_email = EmailTemplate.find_by(title: "Request Info Email")
    expect(request_info_email).to be_present
    expect(request_info_email.title).to eq("Request Info Email")
    expect(request_info_email.body).to include("I am the original content of the request info email")
  end
end
