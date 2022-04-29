# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_pages
#
#  id          :bigint           not null, primary key
#  last_editor :bigint           not null
#  permissions :string           not null
#  slug        :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint           not null
#
# Indexes
#
#  index_dynamic_pages_on_slug  (slug) UNIQUE
#
class DynamicPage < ApplicationRecord
  validates :slug, uniqueness: true
  has_rich_text :body

  def admin_permissions?
    permissions == "Admin"
  end

  def verified_teacher_permissions?
    permissions == "Verified Teacher"
  end
end
