# frozen_string_literal: true

class DropBooleanFromTeachers < ActiveRecord::Migration[5.2]
  def change
    remove_column :teachers, :boolean
    remove_column :teachers, :school_name
  end
end
