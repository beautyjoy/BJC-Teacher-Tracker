# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailAddress, type: :model do
  describe "validations" do
    it "is invalid with an incorrect email format" do
      teacher = Teacher.create(first_name: "John", last_name: "Doe", admin: false)
      email_address = EmailAddress.new(email: "invalid-email", teacher:, primary: false)

      expect(email_address.valid?).to be false
      expect(email_address.errors[:email]).to include("is invalid")
    end

    it "is invalid without an email" do
      teacher = Teacher.create(first_name: "John", last_name: "Doe", admin: false)
      email_address = EmailAddress.new(teacher:, primary: false)

      expect(email_address.valid?).to be false
      expect(email_address.errors[:email]).to include("can't be blank")
    end

    it "is valid with a correct email format" do
      teacher = Teacher.create(first_name: "John", last_name: "Doe", admin: false)
      email_address = EmailAddress.new(email: "valid.email@berkeley.edu", teacher:, primary: false)

      expect(email_address.valid?).to be true
    end
  end
end
