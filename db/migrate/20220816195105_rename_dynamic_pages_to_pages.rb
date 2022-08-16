class RenameDynamicPagesToPages < ActiveRecord::Migration[6.1]
  def change
    rename_table :dynamic_pages, :pages
  end
end
