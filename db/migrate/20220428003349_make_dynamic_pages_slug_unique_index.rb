# frozen_string_literal: true

class MakeDynamicpageslugUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :dynamic_pages, :slug, unique: true
  end
end
