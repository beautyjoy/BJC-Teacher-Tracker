# frozen_string_literal: true

class AddTimestampsToAllTables < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :schools, default: DateTime.now
    add_timestamps :teachers, default: DateTime.now
    add_timestamps :admins, deafult: DateTime.now
  end
end
