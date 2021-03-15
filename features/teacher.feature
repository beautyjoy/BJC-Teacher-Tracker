Feature: teacher login functionality

    As a teacher who has an application
    So that I can edit my information
    I can login via gmail

Scenario: Logging in as a teacher should be able to edit their info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher email
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Google
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"
  And   I enter my "First Name" as "Joe"
  And   I enter my "School Name" as "Cupertino High School"
  And   I enter my "City" as "Cupertino"
  And   I select "CA" from "State"
  And   I enter my "School Website" as "https://chs.fuhsd.org"
  And   I press "Update"
  Then  I see a confirmation "Successfully updated your information"
  Then  the "First Name" field should contain "Joe"

Scenario: Logged in teacher can only edit their own information
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu  |
  | Jane       | Austin    | false | testteacher2@berkeley.edu |
  Given I have a teacher email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should see "You can only edit your own information"

Scenario: Logging in as a teacher should see "Update" instead of "Submit" when editing info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu  |
  Given I have a teacher email
  Given I am on the BJC home page
  Then I should see a button named "Submit"
  Given I follow "Log In"
  Then I can log in with Google
  Then I should see a button named "Update"

Scenario: Frontend should not allow Teacher to edit their email
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane |
  Given I have a teacher email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  And  I enter my "School Email" as "wrong@berkeley.edu"
  And  I enter my "Snap! Username" as "wrong"
  Then the "School Email" field should contain "testteacher@berkeley.edu"
  Then the "Snap!" field should contain "Jane"
