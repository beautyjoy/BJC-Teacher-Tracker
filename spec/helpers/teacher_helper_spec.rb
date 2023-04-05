# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeacherHelper, type: :helper do
  fixtures :all

  let(:teacher) { teachers(:bob) }

  it "helpers snap_link displays correctly" do
    expect(snap_link(teacher)).to eq "<a target=\"_blank\" href=\"https://snap.berkeley.edu/user?user=BobJohnson\">BobJohnson</a>"
  end

  it "helpers ip_history_display displays correctly" do
    expect(ip_history_display(teacher)).to eq "-"
  end
end
