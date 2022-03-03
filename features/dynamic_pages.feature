Feature: email template features

    As an admin, I should be able to view and edit email templates

Background: I am logged in as an admin, and email templates are generated
    Given I seed data
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    And I should see "BJC Teacher Dashboard"
