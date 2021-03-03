Feature: basic admin functionality

  As an admin
  So that I can see how many people are teaching BJC
  I can login in an see the dashboard

Scenario: Logging in as an admin
  Given I am on the BJC home page
  Given I have an admin email
  And I follow "Log In"
  Then I can log in with Google
  And I should see "BJC Teacher Dashboard"

Scenario: Viewing all teachers as an admin
  Given I am on the BJC home page
  Given I have an admin email
  And I follow "Log In"
  Then I can log in with Google
  When I go to the teachers page
  Then I should see "All BJC Teachers"

# TODO: Add steps to check basic dashboard functions
# A search field should be visible on the index pages
# Check for a CSV button

Scenario: Logging in as a teacher should be able to edit their info
  Given the following teachers exist:
  | first_name | last_name | admin | email                |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu |
  Given I have a teacher email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  And I should see "You can edit your information"

Scenario: Logging in with random Google Account should fail
  Given I have a random email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  And I should see "Please Submit a teacher request"

Scenario: Logging in as an env-removed admin should not give admin access
  Given the following teachers exist:
  | first_name | last_name | admin | email                        |
  | Joseph     | Mamoa     | true  | testteacheruser@berkeley.edu |
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google as Teacher
  And I should see "Please Submit a teacher request"

