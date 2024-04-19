Feature: view schools
    As an admin
    So that I can add schools to the database
    I can view teachers by schools

Scenario: Viewing the schools page should show the all current schools
    Given the following schools exist:
    |       name        |     country     |     city     |  state  |            website            |
    |   UC Irvine       |       US        |   Irvine     |   CA    |   https://www.uci.edu         |
    |   UC Scam Diego   |       US        |   La Jolla   |   CA    |   https://www.ucsd.edu        |
    And the following teachers exist:
    |  first_name  |   last_name   |  admin  |       primary_email        |    school   |
    |    Admin     |      User     |   true  | testadminuser@berkeley.edu | UC Berkeley |
    |    Joseph    |     Mamoa     |  false  | jmomoa@berkeley.edu   | UC Berkeley |
    |    Dwayne    |    Johnson    |  false  | djohnson@berkeley.edu | UC Berkeley |
    |    Derek     |    Eeznutz    |  true   | deeznutz@uci.edu      | UC Irvine   |
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    And I am on the schools page
    # Don't try to count berkeley teachers due to seed data.
    Then I should see "UC Berkeley"
    And I should see "UC Irvine" with "1" in a table row
    And I should see "UC Scam Diego" with "0" in a table row

Scenario: Admins can see Tags and NCES ID
    Given the following teachers exist:
    | first_name | last_name | admin | primary_email                |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the new schools page
    And I fill in the school name selectize box with "Any value" and choose to add a new school
    Then I should see "Tags"
    And I should see "NCES ID"

Scenario: Admins can create new schools
    Given the following teachers exist:
    | first_name | last_name | admin | primary_email                |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the new schools page
    And I fill in the school name selectize box with "New UC Berkeley" and choose to add a new school
    And I select "United States" from "Country"
    And I fill in "City" with "Berkeley"
    And I select "CA" from "State" dropdown
    And I fill in "School Website" with "https://www.berkeley.edu/"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I fill in "NCES ID" with "123456789100"
    And I press "Submit"
    Then I should see "New UC Berkeley" with "0" in a table row

Scenario: User can create an international school
    Given "razztech@berkeley.edu" is not in the database
    Given I am on the BJC home page
    And   I enter my "First Name" as "Razvan"
    And   I enter my "Last Name" as "Turcu"
    And   I enter my "School Email" as "razztech@berkeley.edu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I set my education level target as "High School"
    And   I fill in "More Information" with "I am after school volunteer"
    And   I enter my "Personal or Course Website" as "https://chs.fuhsd.org"
    And   I fill in the school name selectize box with "Bucharest International School" and choose to add a new school
    And   I select "Romania" from "Country"
    And   I enter my "City" as "Bucharest"
    And   I fill in state with "Bucharest, Sector 1"
    And   I enter my "School Website" as "https://chs.fuhsd.org"
    And   I select "University" from "Grade Level"
    And   I select "Public" from "School Type"
    And   I press "Submit"
    Then  I see a confirmation "Thanks for signing up for BJC"

Scenario: Admin can see international schools in the submission
    Given "razztech@berkeley.edu" is not in the database
    Given I am on the BJC home page
    And   I enter my "First Name" as "Razvan"
    And   I enter my "Last Name" as "Turcu"
    And   I enter my "School Email" as "razztech@berkeley.edu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I set my education level target as "High School"
    And   I fill in "More Information" with "I am after school volunteer"
    And   I enter my "Personal or Course Website" as "https://chs.fuhsd.org"
    And   I fill in the school name selectize box with "Bucharest International School" and choose to add a new school
    And   I select "Romania" from "Country"
    And   I enter my "City" as "Bucharest"
    And   I fill in state with "Bucharest, Sector 1"
    And   I enter my "School Website" as "https://chs.fuhsd.org"
    And   I select "University" from "Grade Level"
    And   I select "Public" from "School Type"
    And   I press "Submit"
    And   I see a confirmation "Thanks for signing up for BJC"
    Then I should find a teacher with email "razztech@berkeley.edu" and school country "RO" in the database

Scenario: Attempt to create an international school with missing mandatory fields
    Given "razztech@berkeley.edu" is not in the database
    And I am on the BJC home page
    And I enter my "First Name" as "Perry"
    And I enter my "Last Name" as "Zhong"
    And I enter my "School Email" as "jzhong12@berkeley.edu"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in "More Information" with "I am after school volunteer"
    And I enter my "Personal or Course Website" as "https://chs.fuhsd.org"
    And I fill in the school name selectize box with "Bucharest International School" and choose to add a new school
    # Leaving out mandatory fields "Country", "City", and "School Website" to simulate user error
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then the new teacher form should not be submitted
