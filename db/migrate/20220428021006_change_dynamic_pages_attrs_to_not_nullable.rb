# frozen_string_literal: true

class ChangeDynamicPagesAttrsToNotNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :dynamic_pages, :title, false
    change_column_null :dynamic_pages, :permissions, false
    change_column_null :dynamic_pages, :creator_id, false
    change_column_null :dynamic_pages, :last_editor, false
  end
end
