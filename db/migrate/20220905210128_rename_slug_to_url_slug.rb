class RenameSlugToUrlSlug < ActiveRecord::Migration[6.1]
  def change
    rename_column :pages, :slug, :url_slug
    rename_column :pages, :permissions, :viewer_permissions
  end
end
