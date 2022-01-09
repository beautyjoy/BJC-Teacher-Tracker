# frozen_string_literal: true

class FixDateTimeDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column_default :admins, :created_at, -> { 'NOW()' }
    change_column_default :admins, :updated_at, -> { 'NOW()' }
    change_column_default :teachers, :created_at, -> { 'NOW()' }
    change_column_default :teachers, :updated_at, -> { 'NOW()' }
  end
end
