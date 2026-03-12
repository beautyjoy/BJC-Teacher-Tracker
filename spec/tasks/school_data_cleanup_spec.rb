# frozen_string_literal: true

# ============================================================================
# RSpec tests for the school data cleanup rake tasks defined in
# lib/tasks/school_data_cleanup.rake
#
# These tests verify two rake tasks:
#   1) schools:fix_countries  — fixes missing/invalid country on schools
#   2) schools:fix_grade_levels — fixes grade_level mismatches based on
#      school name keywords and teacher education levels
#
# Key conventions used here:
#   - FactoryBot creates test records (school, teacher).
#   - We use `update_column` to set "bad" data directly in the DB,
#     bypassing ActiveRecord validations that would normally prevent
#     saving a school with country: nil, etc.
#   - After running a rake task we call `record.reload` so we read
#     the actual DB value, not a stale in-memory copy.
#   - Each test calls `task.reenable` so the same task can be invoked
#     multiple times across different examples.
# ============================================================================

require "rails_helper"
require "rake"

RSpec.describe "school_data_cleanup rake tasks" do
  # --------------------------------------------------------------------------
  # Load the rake file once for the entire describe block.
  # Rails.application.load_tasks would load *all* tasks; instead we load
  # only the file under test, which is faster and avoids side effects.
  # --------------------------------------------------------------------------
  before(:all) do
    # Tell Rake about our application so it can resolve :environment.
    Rake.application = Rake::Application.new

    # Define the :environment task as a no-op.
    # In production this boots Rails, but in tests Rails is already loaded.
    Rake::Task.define_task(:environment)

    # Load the rake file that contains the tasks we want to test.
    Rake.application.rake_require(
      "tasks/school_data_cleanup",     # path relative to lib/
      [Rails.root.join("lib").to_s]    # tell Rake where to look
    )
  end

  # --------------------------------------------------------------------------
  # schools:fix_countries
  # --------------------------------------------------------------------------
  describe "schools:fix_countries" do
    # Grab a reference to the task object so we can invoke and reenable it.
    let(:task) { Rake::Task["schools:fix_countries"] }

    # After every example, reenable the task.
    # Rake tasks are "single-fire" by default — once invoked they won't
    # run again unless you explicitly reenable them.
    after(:each) { task.reenable }

    # We must set APPLY=true so the task actually writes to the DB.
    # Without it the task runs in dry-run mode and changes nothing.
    around(:each) do |example|
      # Temporarily set the environment variable for this test.
      original = ENV["APPLY"]
      ENV["APPLY"] = "true"
      example.run
    ensure
      # Restore the previous value (usually nil) after the test.
      ENV["APPLY"] = original
    end

    # -----------------------------------------------------------------------
    # Scenario: A school has country: nil but a valid US state.
    # Expected: The task sets country to "US" via the state-abbreviation
    #           heuristic (Strategy a).
    # -----------------------------------------------------------------------
    it "assigns 'US' to a school with nil country and a valid US state" do
      # Create a normal school via the factory (country defaults to "US").
      school = create(:school, state: "CA")

      # Now force country to nil directly in the DB, skipping validations.
      # This simulates a legacy record that predates the country column.
      school.update_column(:country, nil)

      # Sanity-check: make sure the DB actually has nil.
      expect(school.reload.country).to be_nil

      # Run the rake task (suppress puts output to keep test output clean).
      expect { task.invoke }.to output.to_stdout

      # Reload from DB and verify the task fixed the country.
      school.reload
      expect(school.country).to eq("US")
    end

    # -----------------------------------------------------------------------
    # Scenario: A school with country: nil and a .ro website TLD.
    # Expected: The task sets country to "RO" via the TLD heuristic
    #           (Strategy b).
    # -----------------------------------------------------------------------
    it "infers country from a non-generic website TLD" do
      # Create a school with valid data first (state is required when country is US).
      school = create(:school, website: "https://www.scoala.ro")

      # Now simulate a legacy international record: wipe country AND state.
      # We use update_column to bypass validations (state can't be nil for US schools).
      school.update_column(:country, nil)
      school.update_column(:state, nil)

      expect { task.invoke }.to output.to_stdout

      school.reload
      # "RO" is the ISO alpha-2 code for Romania.
      expect(school.country).to eq("RO")
    end

    # -----------------------------------------------------------------------
    # Scenario: A school already has a valid country ("US").
    # Expected: The task does NOT touch it — the record should remain
    #           exactly as it was.
    # -----------------------------------------------------------------------
    it "does not modify a school that already has a valid country" do
      school = create(:school, country: "US", state: "NY")

      # Record the timestamp before the task runs.
      original_updated_at = school.updated_at

      expect { task.invoke }.to output.to_stdout

      school.reload
      # Country should still be "US".
      expect(school.country).to eq("US")
      # updated_at should be unchanged because update_column was never called.
      expect(school.updated_at).to eq(original_updated_at)
    end

    # -----------------------------------------------------------------------
    # Scenario: A school has country: nil, a .com website, and no state.
    # Expected: The task cannot infer the country (generic TLD + no state),
    #           so the country stays nil.
    # -----------------------------------------------------------------------
    it "leaves country nil when no heuristic can determine it" do
      # Create with valid data, then wipe country + state via update_column
      # to simulate an unfixable legacy record.
      school = create(:school, website: "https://example.com")

      school.update_column(:country, nil)
      school.update_column(:state, nil)
      # Also clear lat/lng so reverse geocoding can't help either.
      school.update_column(:lat, nil)
      school.update_column(:lng, nil)

      expect { task.invoke }.to output.to_stdout

      school.reload
      # Country should still be nil — the task couldn't fix it.
      expect(school.country).to be_nil
    end

    # -----------------------------------------------------------------------
    # Scenario: Dry-run mode (APPLY is not "true").
    # Expected: The task reports the problem but does NOT write to the DB.
    # -----------------------------------------------------------------------
    it "does not write changes in dry-run mode" do
      school = create(:school, state: "CA")
      school.update_column(:country, nil)

      # Override the APPLY env var to something other than "true".
      ENV["APPLY"] = "false"

      expect { task.invoke }.to output.to_stdout

      school.reload
      # Country should still be nil because dry-run doesn't save.
      expect(school.country).to be_nil
    end
  end

  # --------------------------------------------------------------------------
  # schools:fix_grade_levels
  # --------------------------------------------------------------------------
  describe "schools:fix_grade_levels" do
    let(:task) { Rake::Task["schools:fix_grade_levels"] }

    after(:each) { task.reenable }

    around(:each) do |example|
      original = ENV["APPLY"]
      ENV["APPLY"] = "true"
      example.run
    ensure
      ENV["APPLY"] = original
    end

    # -----------------------------------------------------------------------
    # Scenario: HIGH CONFIDENCE — both heuristics agree.
    # A school named "Springfield High School" is set to elementary (0),
    # and it has two teachers whose education_level is high_school (1).
    # Both name keyword ("high school") and teacher majority point to
    # high_school → the task should auto-fix it.
    # -----------------------------------------------------------------------
    it "fixes grade_level when both name and teacher heuristics agree (high confidence)" do
      # Create a school named "Springfield High School" but with the
      # wrong grade_level of :elementary.
      school = create(:school, name: "Springfield High School", grade_level: :elementary)

      # Create two teachers linked to this school, both teaching high school.
      # education_level enum on Teacher: middle_school=0, high_school=1, college=2
      create(:teacher, school: school, education_level: :high_school,
                       snap: "teacher_hs_1")
      create(:teacher, school: school, education_level: :high_school,
                       snap: "teacher_hs_2")

      expect { task.invoke }.to output.to_stdout

      school.reload
      # The task should have corrected grade_level to :high_school (enum value 2).
      expect(school.grade_level).to eq("high_school")
    end

    # -----------------------------------------------------------------------
    # Scenario: LOW CONFIDENCE — only the name heuristic fires.
    # A school named "City Elementary" is set to high_school, but it has
    # no teachers (or teachers with no education_level set).
    # The name says "elementary" but with no teacher data to confirm,
    # the task should flag it but NOT apply the fix.
    # -----------------------------------------------------------------------
    it "does not auto-fix when only the name heuristic fires (low confidence)" do
      school = create(:school, name: "City Elementary", grade_level: :high_school)

      # No teachers linked → teacher heuristic can't contribute.
      expect { task.invoke }.to output.to_stdout

      school.reload
      # Grade level should remain unchanged because low-confidence fixes
      # are not applied automatically.
      expect(school.grade_level).to eq("high_school")
    end

    # -----------------------------------------------------------------------
    # Scenario: A school whose name and grade_level already match.
    # Expected: The task should not flag or modify it.
    # -----------------------------------------------------------------------
    it "does not modify a school whose grade_level is already correct" do
      school = create(:school, name: "Oak High School", grade_level: :high_school)

      original_updated_at = school.updated_at

      expect { task.invoke }.to output.to_stdout

      school.reload
      expect(school.grade_level).to eq("high_school")
      expect(school.updated_at).to eq(original_updated_at)
    end

    # -----------------------------------------------------------------------
    # Scenario: Teacher-only mismatch (no name keyword).
    # A school with a generic name "Learning Academy" is set to elementary,
    # but all its teachers report education_level: high_school.
    # Only the teacher heuristic fires → low confidence → no auto-fix.
    # -----------------------------------------------------------------------
    it "does not auto-fix when only teacher heuristic fires (low confidence)" do
      school = create(:school, name: "Learning Academy", grade_level: :elementary)

      create(:teacher, school: school, education_level: :high_school,
                       snap: "hs_teacher_1")
      create(:teacher, school: school, education_level: :high_school,
                       snap: "hs_teacher_2")

      expect { task.invoke }.to output.to_stdout

      school.reload
      # Should remain elementary — only one heuristic fired, so low confidence.
      expect(school.grade_level).to eq("elementary")
    end

    # -----------------------------------------------------------------------
    # Scenario: Dry-run mode for grade level fixes.
    # Even with a high-confidence mismatch, nothing should be saved.
    # -----------------------------------------------------------------------
    it "does not write changes in dry-run mode" do
      school = create(:school, name: "Springfield High School", grade_level: :elementary)

      create(:teacher, school: school, education_level: :high_school,
                       snap: "dry_run_teacher_1")
      create(:teacher, school: school, education_level: :high_school,
                       snap: "dry_run_teacher_2")

      # Turn off APPLY so the task runs in dry-run mode.
      ENV["APPLY"] = "false"

      expect { task.invoke }.to output.to_stdout

      school.reload
      # Grade level should still be :elementary — dry run doesn't save.
      expect(school.grade_level).to eq("elementary")
    end
  end
end
