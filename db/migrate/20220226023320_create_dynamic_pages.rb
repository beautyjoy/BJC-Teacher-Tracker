# frozen_string_literal: true

class CreateDynamicPages < ActiveRecord::Migration[6.1]
  def change
    create_table :dynamic_pages do |t|
      t.string "slug", null: false, unique: true
      t.string "title"
      t.text "body"
      t.string "permissions"

      t.timestamps
    end
  end
end
