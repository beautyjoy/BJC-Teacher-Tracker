# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_pages
#
#  id          :bigint           not null, primary key
#  html        :text
#  last_editor :bigint           not null
#  permissions :string           not null
#  slug        :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint           not null
#  teachers_id :bigint
#
# Indexes
#
#  index_dynamic_pages_on_slug         (slug) UNIQUE
#  index_dynamic_pages_on_teachers_id  (teachers_id)
#
# Foreign Keys
#
#  fk_rails_...  (teachers_id => teachers.id)
#
class DynamicPage < ApplicationRecord
  validates :slug, uniqueness: true
  validates :last_editor, :permissions, :slug, :title, :creator_id, presence: true
  validate :validate_permissions

  def validate_permissions
    if !["Admin", "Verified Teacher", "Public"].include?(permissions)
      errors.add :base, "That permissions is not valid"
    end
  end

  has_rich_text :body

  def admin_permissions?
    permissions == "Admin"
  end

  def verified_teacher_permissions?
    permissions == "Verified Teacher"
  end
end
