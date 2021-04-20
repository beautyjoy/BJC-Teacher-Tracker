class CreateEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :email_templates do |t|
      t.text :body
      t.string :path
      t.string :locale
      t.string :handler
      t.boolean :partial
      t.string :format

      t.timestamps
    end
  end
end
