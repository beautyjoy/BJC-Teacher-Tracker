class AddIpHistoryAndSessionCountToTeacherTable < ActiveRecord::Migration[6.1]
  def change
    add_column :teachers, :ip_history, :inet, array: true, default: []
    add_column :teachers, :session_count, :integer, default: 0
  end
end
