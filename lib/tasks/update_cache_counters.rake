# frozen_string_literal: true

# More robust version to update new or existing counter cache columns in your Rails app.
# See: https://gist.github.com/svyatov/4225663
# https://gist.github.com/joost/7790345#file-update_cache_counters-rake-L12
desc "Update all cache counters"
task update_cache_counters: :environment do
  models_to_update = {}

  # or: Rails.application.eager_load!
  # Dir loads less, so it's faster
  Dir.glob(Rails.root.join("app/models/**/*")).each { |model| require model if File.file?(model) }

  # as a convention, cache counter column name must begin with assotiacion's name and end with '_count' suffix,
  # e.g. 'comments_count', 'posts_count'
  ActiveRecord::Base.descendants.each do |model|
    next if not model.table_exists?
    cache_counters = model.column_names.filter_map { |n| n.delete_suffix("_count").to_sym if n.end_with?("_count") }
    cache_counters.select! { |c| model.reflect_on_association(c) } # check if association is exists
    models_to_update[model] = cache_counters if cache_counters.size > 0
  end

  models_to_update.each do |model, counters|
    model.select(:id).find_each do |record|
      model.reset_counters record.id, *counters
    end
  end
end
