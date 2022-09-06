# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id                 :bigint           not null, primary key
#  html               :text
#  title              :string           not null
#  url_slug           :string           not null
#  viewer_permissions :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  creator_id         :bigint           not null
#  last_editor_id     :bigint           not null
#
# Indexes
#
#  index_pages_on_url_slug  (url_slug) UNIQUE
#
class Page < ApplicationRecord
  validates :url_slug, uniqueness: true
  validates :last_editor, :viewer_permissions, :url_slug, :title, :html, :creator_id, presence: true
  validate :validate_permissions

  before_save :fix_bjc_r_links

  belongs_to :last_editor, class_name: "Teacher"
  belongs_to :creator, class_name: "Teacher"

  # TODO: convert :viewer_permissions to an enum

  def to_param
    self.url_slug
  end

  def validate_permissions
    if !["Admin", "Verified Teacher", "Public"].include?(viewer_permissions)
      errors.add :base, "That permissions is not valid"
    end
  end

  # TODO: This may be a bit too specific?
  def fix_bjc_r_links
    return unless self.html
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
    viewer_permissions == "Admin"
  end

  def verified_teacher_permissions?
    viewer_permissions == "Verified Teacher"
  end
end
