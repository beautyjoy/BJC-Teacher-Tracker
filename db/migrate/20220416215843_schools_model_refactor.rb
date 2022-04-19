# frozen_string_literal: true

class SchoolsModelRefactor < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :grade_level, :integer
    add_column :schools, :type, :integer
    add_column :schools, :tags, :text, array: true, default: []
    add_column :schools, :nces_id, :integer
  end
end
