# frozen_string_literal: true

module PagesHelper
  def organize_into_categories(pages)
    pages.group_by(&:display_category).sort_by { |category, lst| lst[0].category || "" }
  end
end
