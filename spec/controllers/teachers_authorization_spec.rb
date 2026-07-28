# frozen_string_literal: true

require "rails_helper"

# Regression coverage for the before_action lists in TeachersController.
# Each of these actions was previously reachable by any logged-in teacher.
RSpec.describe TeachersController, type: :request do
  fixtures :all

  let(:admin) { teachers(:admin) }
  let(:attacker) { teachers(:validated_teacher) }
  let(:victim) { teachers(:reimu) }

  describe "#import" do
    let(:csv) do
      Rack::Test::UploadedFile.new(
        StringIO.new("first_name,last_name,email\nPwned,ByImport,pwned@example.com\n"),
        "text/csv", original_filename: "teachers.csv"
      )
    end

    it "is not reachable by a logged-in non-admin" do
      log_in(attacker)
      expect { post import_teachers_path, params: { file: csv } }
        .not_to change(Teacher, :count)
      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eq("Only admins can access this page.")
    end

    it "is not reachable when logged out" do
      post import_teachers_path, params: { file: csv }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "#request_info" do
    it "does not let a non-admin change another teacher's application status" do
      log_in(attacker)
      expect { post request_info_teacher_path(victim), params: { skip_email: "1" } }
        .not_to change { victim.reload.application_status }
      expect(response).to redirect_to(root_path)
    end

    it "still lets an admin request info" do
      log_in(admin)
      post request_info_teacher_path(victim), params: { skip_email: "1" }
      expect(victim.reload.application_status).to eq("info_needed")
    end
  end

  describe "#remove_file" do
    before do
      victim.files.attach(
        io: File.open(Rails.root.join("spec/fixtures/test_file.txt")),
        filename: "test_file.txt"
      )
    end

    it "does not let one teacher purge another teacher's file" do
      log_in(attacker)
      expect { delete remove_file_teacher_path(victim), params: { file_id: victim.files.first.id } }
        .not_to change { victim.reload.files.count }
      expect(flash[:alert]).to eq("You can only edit your own information")
    end

    it "still lets an admin remove a file" do
      log_in(admin)
      expect { delete remove_file_teacher_path(victim), params: { file_id: victim.files.first.id } }
        .to change { victim.reload.files.count }.from(1).to(0)
    end
  end

  describe "#upload_file" do
    let(:upload) do
      Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test_file.txt"), "text/plain")
    end

    it "does not let one teacher attach a file to another teacher's record" do
      log_in(attacker)
      expect { post upload_file_teacher_path(victim), params: { file: upload } }
        .not_to change { victim.reload.files.count }
      expect(flash[:alert]).to eq("You can only edit your own information")
    end

    it "still lets a teacher attach a file to their own record" do
      log_in(attacker)
      expect { post upload_file_teacher_path(attacker), params: { file: upload } }
        .to change { attacker.reload.files.count }.by(1)
    end
  end
end
