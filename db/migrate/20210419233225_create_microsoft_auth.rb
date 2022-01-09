# frozen_string_literal: true

class CreateMicrosoftAuth < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :microsoft_token, :string
    add_column :teachers, :microsoft_refresh_token, :string
  end
end
