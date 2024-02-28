# frozen_string_literal: true

RSpec.shared_context "database verification" do
  before(:all) do
    # Use before(:all) to ensure this check runs once before all tests in the suite
    db_name = ActiveRecord::Base.connection.current_database
    expected_db_name = "bjc_teachers_test"

    if db_name != expected_db_name
      raise "Tests are running against the wrong database: #{db_name}. Expected: #{expected_db_name}."
    end
  end
end
