# frozen_string_literal: true

class ChangeNcesidToText < ActiveRecord::Migration[6.1]
  def change
    change_column :schools, :nces_id, :string
  end
end
