class AddHtmlToDynamicPages < ActiveRecord::Migration[6.1]
  def change
    add_column :dynamic_pages, :html, :text
  end
end
