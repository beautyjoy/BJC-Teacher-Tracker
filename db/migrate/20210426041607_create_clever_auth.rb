# frozen_string_literal: true

class CreateCleverAuth < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :clever_token, :string
    add_column :teachers, :clever_refresh_token, :string
  end
end
