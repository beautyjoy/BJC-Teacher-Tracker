class FixSchoolCreatedAtTime < ActiveRecord::Migration[5.2]
  def change
    change_column_default :schools, :created_at, -> { 'NOW()' }
    change_column_default :schools, :updated_at, -> { 'NOW()' }
  end
end
