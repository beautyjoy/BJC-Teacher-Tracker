# frozen_string_literal: true

namespace :split_teacher_pending_state do
  desc "Change all the pending state into not_reviewed state"
  task split: :environment do
    puts "Updating Pending/nil status to not_reviewed"
    puts "Pending -> not reviewed"
    puts Teacher.where(application_status: "Pending").update_all(application_status: "not_reviewed")
    puts "Nil -> not_reviewed"
    puts Teacher.where(application_status: nil).update_all(application_status: "not_reviewed")
    puts "empty string -> not_reviewed"
    puts Teacher.where(application_status: "").update_all(application_status: "not_reviewed")
    puts "Done."
  end
end
