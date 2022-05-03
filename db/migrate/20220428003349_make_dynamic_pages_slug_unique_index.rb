# frozen_string_literal: true

class MakeDynamicPagesSlugUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :dynamic_pages, :slug, unique: true
  end
end
