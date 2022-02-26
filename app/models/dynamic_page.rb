# frozen_string_literal: true

class DynamicPage < ApplicationRecord
  def self.create_dynamic_page(dunamic_page_hash)
    if DynamicPage.find_by(slug: params[:slug]).blank?
      DynamicPage.create!(dunamic_page_hash)
  end
end
