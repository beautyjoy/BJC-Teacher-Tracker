# frozen_string_literal: true

require "rails_helper"

describe TeacherMailer do
  fixtures :all
  before(:all) do
    Rails.application.load_seed
  end
  it "Sends Welcome Email" do
     teacher = teachers(:bob)
     email = TeacherMailer.welcome_email(teacher)
     email.deliver_now
     expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
     expect(email.to[0]).to eq("bob@gmail.com")
     expect(email.subject).to eq("Welcome to The Beauty and Joy of Computing!")
     expect(email.body.encoded).to include("Hi Bob")
   end


  it "Sends Deny Email" do
    teacher = teachers(:long)
    email = TeacherMailer.deny_email(teacher, "Denial Reason")
    email.deliver_now
    expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
    expect(email.to[0]).to eq("short@long.com")
    expect(email.subject).to eq("Deny Email")
    expect(email.body.encoded).to include("Denial Reason")
  end

  it "Sends Form Submission Email" do
    teacher = teachers(:long)
    email = TeacherMailer.form_submission(teacher)
    email.deliver_now
    expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
    expect(email.to[0]).to eq("lmock@berkeley.edu")
    expect(email.body.encoded).to include("Short Long")
  end
end
