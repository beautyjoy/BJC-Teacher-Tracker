# frozen_string_literal: true

class CreateDynamicPages < ActiveRecord::Migration[6.1]
  def change
    create_table :dynamic_pages do |t|
      t.string "slug", unique: true, null: false
      t.string "title"
      t.text "body"
      t.string "permissions"

      t.timestamps
    end
  end
end
