# frozen_string_literal: true

class ChangeSchoolsNcesIdToBigInt < ActiveRecord::Migration[6.1]
  def change
    change_column :schools, :nces_id, :bigint
  end
end
