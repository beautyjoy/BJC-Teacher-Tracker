# frozen_string_literal: true

require "rails_helper"

# The existing merge_controller_spec only covers school merges.
RSpec.describe MergeController, "teacher merges", type: :request do
  fixtures :all

  let(:admin) { teachers(:admin) }
  let(:from_teacher) { teachers(:barney) }
  let(:into_teacher) { teachers(:bob) }

  before { log_in(admin) }

  it "keeps the merged-in email addresses instead of destroying them with the old record" do
    moved = from_teacher.email_addresses.pluck(:email)
    expect(moved).not_to be_empty

    patch merge_path(from: from_teacher.id, into: into_teacher.id)

    expect(Teacher.exists?(from_teacher.id)).to be(false)
    expect(into_teacher.reload.email_addresses.pluck(:email)).to include(*moved)
    # Login resolves through EmailAddress, so a dropped row locks the teacher out.
    moved.each { |email| expect(EmailAddress.find_by(email:)).to be_present }
  end

  it "does not promote a non-admin by merging an admin into them" do
    from_teacher.update!(admin: true)
    expect(into_teacher.admin).to be(false)

    patch merge_path(from: from_teacher.id, into: into_teacher.id)

    expect(into_teacher.reload.admin).to be(false)
  end

  it "sums session counts rather than treating a zero count as missing" do
    from_teacher.update!(session_count: 3)
    into_teacher.update!(session_count: 0)

    patch merge_path(from: from_teacher.id, into: into_teacher.id)

    expect(into_teacher.reload.session_count).to eq(3)
  end
end
