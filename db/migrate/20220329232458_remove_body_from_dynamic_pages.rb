# frozen_string_literal: true

class RemoveBodyFromDynamicPages < ActiveRecord::Migration[6.1]
  def change
    remove_column :dynamic_pages, :body
  end
end
