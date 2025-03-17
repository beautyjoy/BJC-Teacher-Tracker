# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id                 :integer          not null, primary key
#  admin              :boolean          default(FALSE)
#  application_status :string           default("not_reviewed")
#  education_level    :integer          default(NULL)
#  email              :string
#  first_name         :string
#  ip_history         :inet             default([]), is an Array
#  languages          :string           default(["\"English\""]), is an Array
#  last_name          :string
#  last_session_at    :datetime
#  more_info          :string
#  personal_email     :string
#  personal_website   :string
#  session_count      :integer          default(0)
#  snap               :string
#  status             :integer
#  created_at         :datetime
#  updated_at         :datetime
#  last_editor_id     :bigint
#  school_id          :integer
#  verified_by_id     :bigint
#
# Indexes
#
#  index_teachers_on_email                     (email) UNIQUE
#  index_teachers_on_email_and_first_name      (email,first_name)
#  index_teachers_on_email_and_personal_email  (email,personal_email) UNIQUE
#  index_teachers_on_last_editor_id            (last_editor_id)
#  index_teachers_on_school_id                 (school_id)
#  index_teachers_on_snap                      (snap) UNIQUE WHERE ((snap)::text <> ''::text)
#  index_teachers_on_status                    (status)
#  index_teachers_on_verified_by_id            (verified_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (last_editor_id => teachers.id)
#  fk_rails_...  (school_id => schools.id)
#  fk_rails_...  (verified_by_id => teachers.id)
#
require "rails_helper"

RSpec.describe Teacher, type: :model do
  fixtures :all

  let(:teacher) { teachers(:bob) }

  it "formats a proper email name" do
    expect(teacher.email_name).to eq "Bob Johnson <bob@gmail.com>"
  end

  it "formats a proper email name filtering commas" do
    teacher.update(last_name: "Johnson, III")
    expect(teacher.email_name).to eq "Bob Johnson III <bob@gmail.com>"
  end

  it "should be valid" do
    expect(teacher.valid?).to be true
  end

  it "shows a text status" do
    expect(teacher.text_status).to eq "I am teaching BJC but not as an AP CS Principles course."
  end

  it "shows a short status" do
    expect(teacher.display_status).to eq "Non CSP Teacher"
  end

  it "shows an application status" do
    expect(teacher.display_application_status).to eq "Denied"
  end

  it "shows Unknown education level" do
    expect(teacher.display_education_level).to eq "?"
  end

  describe "teacher with info_needed application status" do
    let(:teacher) { teachers(:reimu) }

    it "does not change a info_need status to not_reviewed if submitted without changes" do
      expect do
        # Same primary email, which means no any change compared to last time
        teacher.email_addresses.find_by(email: "reimu@touhou.com").update(primary: true)
      end.not_to change(teacher, :application_status)
    end

    it "changes a info_needed status to not_reviewed" do
      expect do
        # Changes the status to not_reviewed only when there are meaningful changes
        teacher.email_addresses.find_by(email: "reimu@touhou.com").update(email: "reimu_different_email@touhou.com")
      end.to change(teacher, :application_status)
               .from("info_needed").to("not_reviewed")
    end

    it "can change a not_reviewed status to info_needed" do
      expect(teacher.more_info).to eq "Best Touhou Character"
      expect do
        teacher.update(more_info: "updated info")
      end.to change(teacher, :more_info)
               .from("Best Touhou Character").to("updated info")
    end
  end

  describe "teacher with more info" do
    let(:teacher) { teachers(:admin) }

    it "shows a short status with more info" do
      expect(teacher.more_info).to eq "A CS169 Student"
      expect(teacher.display_status).to eq "Other | A CS169 Student"
    end

    it "shows an application status" do
      expect(teacher.display_application_status).to eq "Validated"
    end
  end

  describe "teacher with not_reviewed application status" do
    let(:teacher) { teachers(:long) }

    it "shows an application status" do
      expect(teacher.display_application_status).to eq "Not Reviewed"
    end
  end

  describe "#track_last_editor" do
    let(:editor) { teachers(:admin) }
    let(:new_teacher) { create(:teacher, last_editor_id: nil) }

    before do
      # All new_teacher updates, including create will have last_editor set to editor
      allow(Current).to receive(:user).and_return(nil)
    end

    it "updates last_editor when attributes change" do
      allow(Current).to receive(:user).and_return(editor)
      new_teacher.first_name = "New Name"
      new_teacher.save
      new_teacher.reload

      expect(new_teacher.last_editor).to eq(editor)
    end

    it "does not update last_editor when only updated_at changes" do
      # last_editor is currently set to nil, such as when a new teacher is created
      new_teacher.touch
      new_teacher.reload

      expect(new_teacher.last_editor).to eq(nil)
    end

    it "does not update last_editor when only tracking attributes change" do
      allow(Current).to receive(:user).and_return(new_teacher)
      new_teacher.last_session_at = Time.current
      new_teacher.session_count = 5
      new_teacher.ip_history = ["192.168.1.1"]
      new_teacher.save
      new_teacher.reload

      expect(new_teacher.last_editor).to eq(nil)
    end

    it "updates last_editor when tracking attributes and other attributes change" do
      allow(Current).to receive(:user).and_return(editor)
      new_teacher.first_name = "New Name"
      new_teacher.last_session_at = Time.current
      new_teacher.save
      new_teacher.reload

      expect(new_teacher.last_editor).to eq(editor)
    end
  end
end
