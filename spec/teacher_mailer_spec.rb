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
    end

    it 'Sends Deny Email' do
        teacher = teachers(:long)
        email = TeacherMailer.deny_email(teacher, "Test")
        email.deliver_now
        expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
        expect(email.to[0]).to eq("short@long.com")
        expect(email.subject).to eq("Deny Email")
        expect(email.body.encoded).to include("Test")
    end
end
