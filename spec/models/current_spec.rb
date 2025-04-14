# frozen_string_literal: true

require "rails_helper"

RSpec.describe Current, type: :model do
  fixtures :all

  it "is a subclass of ActiveSupport::CurrentAttributes" do
    expect(Current.ancestors).to include(ActiveSupport::CurrentAttributes)
  end

  it "has user attribute" do
    teacher = teachers(:admin)

    Current.user = teacher
    expect(Current.user).to eq(teacher)

    # Reset between requests
    Current.reset
    expect(Current.user).to be_nil
  end
end
