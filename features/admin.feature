Feature: basic admin functionality

  As an admin
  So that I can see how many people are teaching BJC
  I can login in an see the dashboard

Scenario: Logging in as an admin
  Given I am on the BJC home page
  And I follow "Admin Log In"
  Then I can log in with Google as Admin
  And I should see "BJC Teacher Dashboard"

# TODO: Add steps to check basic dashboard functions
# A search field should be visible on the index pages
# Check for a CSV button

Scenario: Logging in as a non admin should not give admin access
  Given the following teachers exist:
  | first_name | last_name | admin | email                          |
  | Joseph     | Mamoa     | false | "testteacheruser@berkeley.edu" |
  Given I am on the BJC home page
  And I follow "Admin Log In"
  Then I can log in with Google as Teacher
  And I should see "Request Access to Teacher Materials"

Scenario: Logging in as an env-removed admin should not give admin access
  Given the following teachers exist:
  | first_name | last_name | admin | email                          |
  | Joseph     | Mamoa     | true | "testteacheruser@berkeley.edu" |
  Given I am on the BJC home page
  And I follow "Admin Log In"
  Then I can log in with Google as Teacher
  And I should see "Request Access to Teacher Materials"

