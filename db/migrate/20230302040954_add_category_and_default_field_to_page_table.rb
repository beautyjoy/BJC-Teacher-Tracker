class AddCategoryAndDefaultFieldToPageTable < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :default, :boolean
    add_column :pages, :category, :string
  end
end
