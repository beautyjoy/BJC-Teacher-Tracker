Feature: teacher login functionality

    As a teacher who has an application
    So that I can edit my information
    I can login via gmail

Background: See data
  Given I seed data

Scenario: Logging in failure redirects to new teachers page
  Given I am on the BJC home page
  Given I have a teacher Google email
  And   I follow "Log In"
  And   I cannot log in with Google
  Then  I should be on the new teachers page

Scenario: Logging in as a teacher
  Given I am on the BJC home page
  Given I have a teacher Google email
  And   I follow "Log In"
  Then  I should see "Sign in with Google"
  And   I should see "Sign in with Snap"
  And   I should see "Sign in with Microsoft"
  And   I should see "Sign in with Clever"
  Then  the page should be axe clean

Scenario: Logging in as a teacher with Google account should be able to edit their info
  Given the following schools exist:
  |       name            |     city     |  state  |            website            |
  |   UC Berkeley         |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  | Cupertino High School |   Cupertino  |   CA    |      https://chs.fuhsd.org    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher Google email
  And   The TEALS contact email is stubbed
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Google
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"
  And   I enter my "First Name" as "Joe"
  And   I set my status as "I am a TEALS volunteer, and am teaching the BJC curriculum."
  And   I set my education level target as "College"
  And   I fill in the school name selectize box with "Cupertino High School, Cupertino, CA" and choose to add a new school
  And   I enter my "City" as "Cupertino"
  And   I select "CA" from "State"
  And   I enter my "School Website" as "https://chs.fuhsd.org"
  And   I press "Update"
  Then  I see a confirmation "Successfully updated your information"
  Then  the "First Name" field should contain "Joe"
  Then  there is a TEALS email

Scenario: Logging in as a teacher with Microsoft account should be able to edit their info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher Microsoft email
  And   The TEALS contact email is stubbed
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Microsoft
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"

Scenario: Logging in as a teacher with Snap account should be able to edit their info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher Snap email
  And   The TEALS contact email is stubbed
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Snap
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"

  Scenario: Logging in as a teacher with Clever account should be able to edit their info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher Clever email
  And   The TEALS contact email is stubbed
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Clever
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"

Scenario: Logged in teacher can fill a new form with their info
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      | snap   |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley | alonzo |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Google
  When  I go to the new teachers page
  And   I enter my "First Name" as "Joe"
  And   I enter my "Last Name" as "Mamoa"
  And   I enter my "School Email" as "testteacher@berkeley.edu"
  And   I enter my "Snap! Username" as "alonzo"
  And   I set my status as "I am teaching BJC as an AP CS Principles course."
  And   I set my education level target as "High School"
  And   I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
  And   I enter my "City" as "Cupertino"
  And   I select "CA" from "State"
  And   I enter my "School Website" as "https://chs.fuhsd.org"
  And   I press "Submit"
  Then  I see a confirmation "Successfully updated your information"
  And   I am on the edit page for Joe Mamoa

  Scenario: Logged in teacher cannot change Snap from new form path
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      | snap   |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley | alonzo |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Google
  When  I go to the new teachers page
  And   I enter my "First Name" as "Joe"
  And   I enter my "Last Name" as "Mamoa"
  And   I enter my "School Email" as "testteacher@berkeley.edu"
  And   I enter my "Snap! Username" as "not_alonzo"
  And   I set my status as "I am teaching BJC as an AP CS Principles course."
  And   I set my education level target as "High School"
  And   I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
  And   I enter my "City" as "Cupertino"
  And   I select "CA" from "State"
  And   I enter my "School Website" as "https://chs.fuhsd.org"
  And   I press "Submit"
  Then  I see a confirmation "Failed to update your information"
  And   I am on the edit page for Joseph Mamoa

Scenario: Logged in teacher can only edit their own information
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu  |
  | Jane       | Austin    | false | testteacher2@berkeley.edu |
  Given I have a teacher Google email
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
  Given I have a teacher Google email
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
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  And  I enter my "School Email" as "wrong@berkeley.edu"
  And  I enter my "Snap! Username" as "wrong"
  Then the "School Email" field should contain "testteacher@berkeley.edu"
  Then the "Snap!" field should contain "Jane"

Scenario: Validated teacher should see resend button
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | validated          |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should see a button named "Resend Welcome Email"

Scenario: Pending teacher should not see resend button
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | pending          |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should not see "Resend Welcome Email"

Scenario: Denied teacher should not see resend button
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | denied |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should not see "Resend Welcome Email"

Scenario: Validated teacher should not see Tags or NCES ID
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | validated          |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should not see "Tags"
  And I should not see "NCIS ID"

Scenario: Pending teacher should not see Tags or NCES ID
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | pending          |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should not see "Tags"
  And I should not see "NCIS ID"

Scenario: Denied teacher should not see Tags or NCES ID
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                     | snap | application_status |
  | Jane       | Austin    | false | testteacher@berkeley.edu  | Jane | denied |
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the edit page for Jane Austin
  Then I should not see "Tags"
  And I should not see "NCIS ID"

Scenario: Upload valid record csv
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I have a teacher Microsoft email
  And   The TEALS contact email is stubbed
  Given I am on the BJC home page
  And   I follow "Log In"
  Then  I can log in with Microsoft
  And   I see a confirmation "You can edit your information"
  Then  the "First Name" field should contain "Joseph"