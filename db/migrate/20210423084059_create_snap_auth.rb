# frozen_string_literal: true

class CreateSnapAuth < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :snap_token, :string
    add_column :teachers, :snap_refresh_token, :string
  end
end
