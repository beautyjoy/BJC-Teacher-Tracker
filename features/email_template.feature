Feature: email template features

    As an admin, I should be able to view and edit email templates
Background: I am logged in as an admin, and email templates are generated
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I seed data
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    

Scenario: Logging in as an admin should see all email templates
    Given I am on the email templates index
    Then I should see "teacher_mailer/welcome_email"
    Then I should see "teacher_mailer/form_submission"
    Then I should see "teacher_mailer/teals_confirmation_email"

Scenario: Logging in as an admin should be able to edit email templates
    Given I am on the email templates index
    And I follow "teacher_mailer/welcome_email"
    Then I should see "Hi {{teacher_first_name}}"
    And I fill in "email_template_body" with "Test Edit"
    And I press "Update"
    And I follow "teacher_mailer/welcome_email"
    Then I should see "Test Edit"