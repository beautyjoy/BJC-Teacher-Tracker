# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_pages
#
#  id          :bigint           not null, primary key
#  body        :text
#  last_editor :bigint
#  permissions :string
#  slug        :string           not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint
#
class DynamicPage < ApplicationRecord
  has_rich_text :body
  def placeholder; end
end
