# frozen_string_literal: true

module PagesHelper
  def organize_into_categories(pages)
    categories = {}
    pages.each do |page|
      categories[page.display_category] ||= []
      categories[page.display_category] << page
    end
    # Make sure uncategorized pages are at the front
    categories.sort_by { |category, lst| lst[0].category || "" }
  end
end
