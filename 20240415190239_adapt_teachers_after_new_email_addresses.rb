# frozen_string_literal: true

class AdaptTeachersAfterNewEmailAddresses < ActiveRecord::Migration[6.1]
  def change
    remove_index :teachers, name: "index_teachers_on_email_and_first_name"
    remove_index :teachers, name: "index_teachers_on_email_and_personal_email"
    remove_index :teachers, name: "index_teachers_on_email"

    remove_column :teachers, :email
    remove_column :teachers, :personal_email
  end
end
