# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailTemplatesController, type: :controller do
  fixtures :all

  before(:all) do
    Rails.application.load_seed
  end

  it "ERB is not rendered in email templates" do
    allow_any_instance_of(ApplicationController).to receive(:is_admin?).and_return(true)
    welcome_email = EmailTemplate.find_by(path: "teacher_mailer/welcome_email")
    post :update, params: { id: welcome_email.id, email_template: { id: welcome_email.id, body: "<%= @teacher.first_name %>" } }
    teacher = teachers(:bob)
    email = TeacherMailer.welcome_email(teacher)
    email.deliver_now
    expect(email.body.encoded).to include("@teacher.first_name")
  end

  it "should allow liquid variables" do
    allow_any_instance_of(ApplicationController).to receive(:is_admin?).and_return(true)
    welcome_email = EmailTemplate.find_by(path: "teacher_mailer/welcome_email")
    post :update, params: { id: welcome_email.id, email_template: { id: welcome_email.id, body: "Welcome to BJC, {{teacher_first_name}}" } }
    teacher = teachers(:bob)
    email = TeacherMailer.welcome_email(teacher)
    email.deliver_now
    expect(email.body.encoded).to include("Welcome to BJC, Bob")
  end

  it "should allow edit email subject" do
    allow_any_instance_of(ApplicationController).to receive(:is_admin?).and_return(true)
    welcome_email = EmailTemplate.find_by(path: "teacher_mailer/welcome_email")
    post :update, params: { id: welcome_email.id, email_template: { id: welcome_email.id, subject: "Test Subject" } }
    teacher = teachers(:bob)
    email = TeacherMailer.welcome_email(teacher)
    email.deliver_now
    expect(email.subject).to eq("Test Subject")
  end
end
