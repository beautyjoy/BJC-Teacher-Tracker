class ChangeDefaultTeacherApplicationStatus < ActiveRecord::Migration[6.1]
  def change
    change_column_default :teachers, :application_status, from: "Pending", to: "Not Reviewed"
  end
end
