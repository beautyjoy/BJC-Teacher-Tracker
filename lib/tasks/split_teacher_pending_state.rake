# frozen_string_literal: true

namespace :split_teacher_pending_state do
  desc "Change all the pending state into not_reviewed state"
  task split: :environment do
    Teacher.where(application_status: "pending").update_all(application_status: "not_reviewed")
    Teacher.where(application_status: nil).update_all(application_status: "not_reviewed")
  end
end
