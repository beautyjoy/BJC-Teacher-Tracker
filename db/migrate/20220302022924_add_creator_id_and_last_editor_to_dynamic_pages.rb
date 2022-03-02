# frozen_string_literal: true

class AddCreatorIdAndLastEditorToDynamicPages < ActiveRecord::Migration[6.1]
  def change
    add_column :dynamic_pages, :creator_id, :bigint
    add_column :dynamic_pages, :last_editor, :bigint
  end
end
