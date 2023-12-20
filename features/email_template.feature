Feature: email template features

    As an admin, I should be able to view and edit email templates

Background: I am logged in as an admin, and email templates are generated
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    And I should see "BJC Teacher Dashboard"

Scenario: Logging in as an admin should see all email templates
    Given I am on the email templates index
    Then I should see "Welcome Email"
    Then I should see "Form Submission"

Scenario: Logging in as an admin should be able to edit email templates
    Given I am on the email templates index
    And I follow "Welcome Email"
    Then I should see hidden element "Hi {{teacher_first_name}}"
    And I fill in TinyMCE email form with "Test Edit"
    And I press "Submit"
    And I follow "Welcome Email"
    Then I should see hidden element "Test Edit"

Scenario: Logging in as an admin should be able to edit email subject
    Given I am on the email templates index
    And I follow "Welcome Email"
    And I fill in "email_template_subject" with "Test Subject"
    And I press "Submit"
    And I follow "Welcome Email"
    Then the "email_template_subject" field should contain "Test Subject"
