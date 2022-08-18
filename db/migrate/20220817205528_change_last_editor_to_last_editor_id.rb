class ChangeLastEditorToLastEditorId < ActiveRecord::Migration[6.1]
  def change
    rename_column :pages, :last_editor, :last_editor_id
  end
end
