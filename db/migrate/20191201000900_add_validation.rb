class AddValidation < ActiveRecord::Migration
  def change
  	add_column(:teachers, :validated, :boolean)
  end
end
