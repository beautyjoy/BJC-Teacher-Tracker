# frozen_string_literal: true

class AddMoreInfoToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :more_info, :string
    add_column :teachers, :admin, :boolean, default: false
    add_column :teachers, :google_token, :string
    add_column :teachers, :google_token_iv, :string
    add_column :teachers, :google_refresh_token, :string
    add_column :teachers, :google_refresh_token_iv, :string
  end
end
