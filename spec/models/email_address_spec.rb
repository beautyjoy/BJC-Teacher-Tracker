# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailAddress, type: :model do
  fixtures :all

  describe "delivery tracking" do
    let(:email) { email_addresses(:validated_teacher_email) }

    describe "#undelivered_count" do
      it "returns 0 when all emails are delivered" do
        email.update_columns(emails_sent: 10, emails_delivered: 10)
        expect(email.undelivered_count).to eq(0)
      end

      it "returns the difference between sent and delivered" do
        email.update_columns(emails_sent: 10, emails_delivered: 7)
        expect(email.undelivered_count).to eq(3)
      end

      it "never returns negative" do
        email.update_columns(emails_sent: 0, emails_delivered: 0)
        expect(email.undelivered_count).to eq(0)
      end
    end

    describe "#has_undelivered?" do
      it "returns false when no undelivered emails" do
        email.update_columns(emails_sent: 5, emails_delivered: 5)
        expect(email.has_undelivered?).to be false
      end

      it "returns true when there are undelivered emails" do
        email.update_columns(emails_sent: 10, emails_delivered: 7)
        expect(email.has_undelivered?).to be true
      end
    end

    describe "scopes" do
      describe ".bounced" do
        it "returns only bounced email addresses" do
          email.update_column(:bounced, true)
          expect(EmailAddress.bounced).to include(email)
        end

        it "excludes non-bounced email addresses" do
          expect(EmailAddress.bounced).not_to include(email)
        end
      end

      describe ".with_undelivered" do
        it "returns emails where sent > delivered" do
          email.update_columns(emails_sent: 10, emails_delivered: 7)
          expect(EmailAddress.with_undelivered).to include(email)
        end

        it "excludes emails where sent == delivered" do
          email.update_columns(emails_sent: 5, emails_delivered: 5)
          expect(EmailAddress.with_undelivered).not_to include(email)
        end
      end
    end

    describe "default values" do
      it "has 0 emails_sent by default" do
        expect(email.emails_sent).to eq(0)
      end

      it "has 0 emails_delivered by default" do
        expect(email.emails_delivered).to eq(0)
      end

      it "is not bounced by default" do
        expect(email.bounced?).to be false
      end
    end
  end
end
