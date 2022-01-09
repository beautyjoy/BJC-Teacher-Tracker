# frozen_string_literal: true

class AddEducationLevelToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :education_level, :integer, default: -1
  end
end
