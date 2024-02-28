# frozen_string_literal: true

require "rails_helper"

# This test suite verifies the reseeding behavior of EmailTemplate models to ensure
# that email templates are correctly handled (i.e., updated or removed) without duplication
# upon reseeding the database with new seed data. It tests the initial seeding, updates to
# templates, and the removal of templates that are no longer present in the seed data.
RSpec.describe "EmailTemplate Reseed Behavior", type: :model do
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
  # The `load Rails.root.join("db/seeds.rb")` line simulates the seeding action.
  before do
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
    # Initial seed with original data
    load Rails.root.join("db/seeds.rb")
  end

  # This test verifies the entire reseed process by first checking the state after initial seeding,
  # then mocking updated seed data, reseeding, and finally asserting the expected outcomes.
  # It checks for the correct handling of both updated and removed email templates.
  it "correctly handles email templates on reseed without duplication" do
    # Verify original content
    expect(EmailTemplate.count).to eq(2)
    request_info_email = EmailTemplate.find_by(title: "Request Info Email")
    expect(request_info_email.title).to eq("Request Info Email")
    expect(request_info_email.body).to include("I am the original content of the request info email")

    form_submission_email = EmailTemplate.find_by(title: "Form Submission")
    expect(form_submission_email.title).to eq("Form Submission")
    expect(form_submission_email.body).to include("I am the original content of the form submission email")

    # Simulate an update to the seed data by changing the content of one email template
    # and removing another. This prepares for the reseed to test how the application handles
    # updated and removed templates.
    allow(SeedData).to receive(:emails).and_return(
      [
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

    # Final assertions to verify that after reseeding, the email templates in the database
    # reflect the updated seed data: updated content is present, and removed templates are absent.
    expect(EmailTemplate.count).to eq(1)

    request_info_email = EmailTemplate.find_by(title: "Request Info Email")
    expect(request_info_email.title).to eq("Request Info Email")
    expect(request_info_email.body).to include("NEW Template Content of the request info email")

    expect(EmailTemplate.find_by(title: "Form Submission")).to be_nil
  end
end
