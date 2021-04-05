require 'rails_helper'

describe TeacherMailer do
  fixtures :teachers
  it 'Sends Welcome Email' do
    teacher = teachers(:bob)
    email = TeacherMailer.welcome_email(teacher)
    email.deliver_now
    expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
    expect(email.to[0]).to eq("bob@gmail.com")
    expect(email.subject).to eq("Welcome to The Beauty and Joy of Computing!")
    expect(email.body.encoded).to include("Hi Bob,")
  end

  it 'Sends TEALS Confirmation Email' do
    stub_const('TeacherMailer::TEALS_CONTACT_EMAIL', 'testcontactemail@berkeley.edu')
    teacher = teachers(:long)
    email = TeacherMailer.teals_confirmation_email(teacher)
    email.deliver_now
    expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
    expect(email.to[0]).to eq("testcontactemail@berkeley.edu")
    expect(email.subject).to eq("TEALS Confirmation Email")
    expect(email.body.encoded).to include("Short Long")
  end

  it "doesn't Send Wrong TEALS Confirmation Email" do
    teacher = teachers(:bob)
    email = TeacherMailer.teals_confirmation_email(teacher)
    email.deliver_now
    expect(email.from).to be_nil
  end
end
