require "rails_helper"

RSpec.describe EmailTemplate, type: :model do
  describe "#reason?" do
    it "returns true if a reason is present in the body" do
      template = EmailTemplate.new(body: " ... {{ denial_reason }}...")
      expect(template.reason?).to eq(true)
    end

    it "returns true even if there are other liquid filters" do
      template = EmailTemplate.new(body: " ... {{denial_reason|strip_tags}}...")
      expect(template.reason?).to eq(true)
    end

    it "returns false if no reason is in the body" do
      template = EmailTemplate.new
      expect(template.reason?).to eq(false)
    end
  end
end
