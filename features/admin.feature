Feature: basic admin functionality

  As an admin
  So that I can see how many people are teaching BJC
  I can login in an see the dashboard

Background: Has an Admin in DB
  Given the following teachers exist:
  | first_name | last_name | admin | email                        |
  | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |

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

# TODO: Checks for validation and deny belong here.

Scenario: Logging in with random Google Account should fail
  Given I have a random email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  And I should see "Please Submit a teacher request"

Scenario: Edit teacher info as an admin
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I am on the BJC home page
  And The TEALS contact email is stubbed
  Given I have an admin email
  And   I follow "Log In"
  Then  I can log in with Google
  When  I go to the teachers page
  When  I go to the edit page for Joseph Mamoa
  Then  I should see "Joseph"
  And   I enter my "First Name" as "Joe"
  And   I set my status as "Other - Please specify below."
  And   I set my education level target as "College"
  And   I press "Update"
  Then I see a confirmation "Saved"

Scenario: Not logged in should not have access to edit
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  When  I go to the edit page for Joseph Mamoa
  Then  should see "You need to log in to access this."

Scenario: Filter all teacher info as an admin
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name  | admin | email                     | school      | application_status |
  | Victor     | Validateme | false | testteacher1@berkeley.edu | UC Berkeley |      Validated     |
  | Danny      | Denyme     | false | testteacher2@berkeley.edu | UC Berkeley |       Denied       |
  | Peter      | Pendme     | false | testteacher3@berkeley.edu | UC Berkeley |       Pending      |
  Given I am on the BJC home page
  Given I have an admin email
  And   I follow "Log In"
  Then  I can log in with Google
  When  I go to the teachers page
  And   I check "Pending"
  Then  I should see "Peter"
  Then  I should not see "Victor"
  Then  I should not see "Danny"
  And   I check "Validated"
  Then  I should see "Peter"
  Then  I should see "Victor"
  Then  I should not see "Danny"