require 'rails_helper'

describe TeacherMailer do
	fixtures :all
    it 'Sends Welcome Email' do
		teacher = teachers(:bob)
		email = TeacherMailer.welcome_email(teacher)
		email.deliver_now
		expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
		expect(email.to[0]).to eq("bob@gmail.com")
		expect(email.subject).to eq("Welcome to The Beauty and Joy of Computing!")
        expect(email.body.encoded).to include("Works")
	end

    # Prereq: "testadminuser@berkeley.edu" must exist within ENV["TEST_TEALS_CONTACT_EMAIL"]
    it 'Sends TEALS Confirmation Email' do
        teacher = teachers(:long)
        email = TeacherMailer.teals_confirmation_email(teacher)
        email.deliver_now
        expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
        expect(email.to[0]).to eq("testcontactemail@berkeley.edu")
        expect(email.subject).to eq("TEALS Confirmation Email")
        expect(email.body.encoded).to include("Short Long")
    end

    it 'Doesn\'t Send Wrong TEALS Confirmation Email' do
        teacher = teachers(:bob)
        email = TeacherMailer.teals_confirmation_email(teacher)
        email.deliver_now
        expect(email.from).to be_nil
    end
end
