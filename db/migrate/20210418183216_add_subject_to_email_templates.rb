# frozen_string_literal: true

class AddSubjectToEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :email_templates, :subject, :string
  end
end
