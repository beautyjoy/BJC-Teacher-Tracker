Feature: view schools
    As an admin
    So that I can add schools to the database
    I can view teachers by schools

Background: Seed Data Exists
    Given I seed data

Scenario: Viewing the schools page should show the all current schools
    Given the following schools exist:
    |       name        |     city     |  state  |            website            |
    |   UC Irvine       |   Irvine     |   CA    |   https://www.uci.edu         |
    |   UC Scam Diego   |   La Jolla   |   CA    |   https://www.ucsd.edu        |
    And the following teachers exist:
    |  first_name  |   last_name   |  admin  |          email        |    school   |
    |    Admin     |      User     |   true  | testadminuser@berkeley.edu | UC Berkeley |
    |    Joseph    |     Mamoa     |  false  | jmomoa@berkeley.edu   | UC Berkeley |
    |    Dwayne    |    Johnson    |  false  | djohnson@berkeley.edu | UC Berkeley |
    |    Derek     |    Eeznutz    |  true   | deeznutz@uci.edu      | UC Irvine   |
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    And I am on the schools page
    # Berkeley already has 2 users.
    Then I should see "UC Berkeley" with "5" in a table row
    And I should see "UC Irvine" with "1" in a table row
    And I should see "UC Scam Diego" with "0" in a table row

Scenario: Admins can create new schools
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the new schools page
    And I fill in "School Name" with "New UC Berkeley"
    And I fill in "City" with "Berkeley"
    And I select "CA" from "State"
    And I fill in "School Website" with "https://www.berkeley.edu/"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I fill in "NCES ID" with "012345678910"
    And I press "Submit"
    Then I should see "Created New UC Berkeley successfully"
    And I should see "New UC Berkeley" with "0" in a table row
