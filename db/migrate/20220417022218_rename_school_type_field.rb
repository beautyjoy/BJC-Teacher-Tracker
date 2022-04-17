# frozen_string_literal: true

class RenameSchoolTypeField < ActiveRecord::Migration[6.1]
  def change
    rename_column :schools, :type, :school_type
  end
end
