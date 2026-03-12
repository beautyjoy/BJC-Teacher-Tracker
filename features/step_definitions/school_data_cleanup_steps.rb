# frozen_string_literal: true

# ============================================================================
# Step definitions for features/school_data_cleanup.feature
# ============================================================================
#
# These steps:
#   - Create test data with FactoryBot (using the :school and :teacher factories).
#   - Use `update_column` to inject "bad" data that bypasses model validations,
#     simulating the legacy production records the rake tasks are designed to fix.
#   - Invoke the rake tasks programmatically with APPLY=true.
#   - Reload records from the DB and assert the expected values.
#
# Convention: we store created schools in a @schools hash (keyed by name)
# so that later steps can look them up without another DB query.
# ============================================================================

# Keep a hash of schools created during the scenario so "Then" steps can
# find them by name without hitting the DB again unnecessarily.
Before do
  @schools = {}
end

# ============================================================================
# "Given" steps — create test data
# ============================================================================

# ---- Country-related Givens ------------------------------------------------

# Creates a school with country set to nil and a specific US state.
# Example: Given a school "Berkeley Academy" exists with no country and state "CA"
Given(/^a school "([^"]*)" exists with no country and state "([^"]*)"$/) do |name, state|
  # Create a valid school first (factory defaults country to "US").
  school = FactoryBot.create(:school, name: name, state: state)

  # Now force country to nil directly in the DB, bypassing validations.
  # This simulates a legacy record that predates the country column.
  school.update_column(:country, nil)

  # Store the school so later steps can find it.
  @schools[name] = school
end

# Creates a school with country=nil, no state, and a specific website.
# The website's TLD will be used by the task to infer the country.
# Example: Given a school "Berlin Schule" exists with no country and website "https://www.schule.de"
Given(/^a school "([^"]*)" exists with no country and website "([^"]*)"$/) do |name, website|
  # Create with valid defaults first (state is required when country is US).
  school = FactoryBot.create(:school, name: name, website: website)

  # Then simulate a legacy record by wiping country and state directly.
  # We use update_column to bypass model validations.
  school.update_column(:country, nil)
  school.update_column(:state, nil)
  # Also clear lat/lng so reverse geocoding won't kick in accidentally.
  school.update_column(:lat, nil)
  school.update_column(:lng, nil)

  @schools[name] = school
end

# Creates a school that already has a valid country — used to test the
# "no-op" behavior (the task should leave it alone).
# Example: Given a school "UC Berkeley" exists with country "US"
Given(/^a school "([^"]*)" exists with country "([^"]*)"$/) do |name, country|
  school = FactoryBot.create(:school, name: name, country: country)
  @schools[name] = school
end

# ---- Grade-level-related Givens --------------------------------------------

# Creates a school with a specific (possibly wrong) grade level.
# Example: Given a school "Springfield High School" exists with grade level "elementary"
Given(/^a school "([^"]*)" exists with grade level "([^"]*)"$/) do |name, grade_level|
  school = FactoryBot.create(:school, name: name, grade_level: grade_level.to_sym)
  @schools[name] = school
end

# Adds N teachers to an existing school, all with the given education_level.
# This lets us set up the "teacher heuristic" data.
# Example: And the school "Springfield High School" has 2 teachers with education level "high_school"
Given(/^the school "([^"]*)" has (\d+) teachers with education level "([^"]*)"$/) do |name, count, level|
  school = @schools[name] || School.find_by!(name: name)

  count.to_i.times do |i|
    # Each teacher needs a unique snap username (there's a unique index on it).
    FactoryBot.create(
      :teacher,
      school: school,
      education_level: level.to_sym,
      snap: "#{name.parameterize}-teacher-#{i}"
    )
  end
end

# ============================================================================
# "When" step — run the rake task
# ============================================================================

# Invokes the named rake task with APPLY=true so it actually writes to the DB.
# After invoking we reenable the task so it can be invoked again in the next
# scenario (Rake tasks are single-fire by default).
# Example: When I run the rake task "schools:fix_countries"
When(/^I run the rake task "([^"]*)"$/) do |task_name|
  # Make sure Rake knows about our tasks.
  # (Rails auto-loads tasks, but we load explicitly to be safe in test env.)
  Rake::Task.define_task(:environment) unless Rake::Task.task_defined?(:environment)

  # Load the rake file if the task isn't already defined.
  unless Rake::Task.task_defined?(task_name)
    Rake.application.rake_require(
      "tasks/school_data_cleanup",
      [Rails.root.join("lib").to_s]
    )
  end

  # Set APPLY=true so the task writes fixes to the DB.
  ENV["APPLY"] = "true"

  # Invoke the task (capture stdout to keep cucumber output clean).
  Rake::Task[task_name].invoke

  # Reenable so the next scenario can invoke the same task again.
  Rake::Task[task_name].reenable

  # Clean up the env var.
  ENV.delete("APPLY")
end

# ============================================================================
# "Then" steps — assert outcomes
# ============================================================================

# Asserts that the school's country column now equals the expected value.
# Example: Then the school "Berkeley Academy" should have country "US"
Then(/^the school "([^"]*)" should have country "([^"]*)"$/) do |name, expected_country|
  school = @schools[name] || School.find_by!(name: name)

  # Reload from the DB so we see what the rake task actually wrote.
  school.reload

  expect(school.country).to eq(expected_country),
    "Expected school '#{name}' to have country '#{expected_country}', " \
    "but got '#{school.country}'"
end

# Asserts that the school's country is still nil (the task couldn't fix it).
# Example: Then the school "Mystery Academy" should have no country
Then(/^the school "([^"]*)" should have no country$/) do |name|
  school = @schools[name] || School.find_by!(name: name)
  school.reload

  expect(school.country).to be_nil,
    "Expected school '#{name}' to have no country (nil), " \
    "but got '#{school.country}'"
end

# Asserts the school's grade_level enum value.
# Example: Then the school "Springfield High School" should have grade level "high_school"
Then(/^the school "([^"]*)" should have grade level "([^"]*)"$/) do |name, expected_level|
  school = @schools[name] || School.find_by!(name: name)
  school.reload

  expect(school.grade_level).to eq(expected_level),
    "Expected school '#{name}' to have grade_level '#{expected_level}', " \
    "but got '#{school.grade_level}'"
end
