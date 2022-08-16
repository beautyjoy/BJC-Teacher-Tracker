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

  before_save :fix_bjc_r_links

  def validate_permissions
    if !["Admin", "Verified Teacher", "Public"].include?(permissions)
      errors.add :base, "That permissions is not valid"
    end
  end

  # TODO: This may be a bit too specific?
  def fix_bjc_r_links
    self.html = self.html.gsub('="/bjc-r', '="https://bjc.edc.org/bjc-r')
  end

  def self.viewable_pages(user)
    return ["Public"] unless user

    if user.admin?
      ["Admin", "Verified Teacher", "Public"]
    elsif user.validated?
      ["Verified Teacher", "Public"]
    else
      ["Public"]
    end
  end

  def admin_permissions?
    permissions == "Admin"
  end

  def verified_teacher_permissions?
    permissions == "Verified Teacher"
  end
end
