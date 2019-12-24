require 'rails_helper'

describe TeacherMailer do
	fixtures :teachers
	it 'Sends Welcome Email' do
		teacher = teachers(:bob_teacher)
		email = TeacherMailer.welcome_email(teacher)
		email.deliver_now
		expect(email.from[0]).to eq("contact@bjc.berkeley.edu")
		expect(email.to[0]).to eq("bob@gmail.com")
		expect(email.subject).to eq("Welcome to the Beauty and Joy of Computing!")
	end
end