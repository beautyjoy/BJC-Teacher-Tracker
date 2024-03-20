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

Scenario: Creating new email template with blank fields displays flash error
    Given I am on the email templates index
    And I press "New Email Templates"
    When I press "Submit"
    Then I should see "An error occured: Body can't be blank, To can't be blank"

Scenario: Creating and deleting new email template with valid fields succeeds
    Given I am on the email templates index
    And I press "New Email Templates"
    When I fill in "email_template_title" with "Test Email"
    And I fill in "email_template_subject" with "Test Subject"
    And I fill in "email_template_to" with "{{teacher_email}}"
    And I fill in TinyMCE email form with "This is the body of my test email"
    And I press "Submit"
    Then I should see "Created Test Email successfully"
    When I follow the first "❌" link
    And I accept the popup alert
    Then I should be on the email templates index
    And I should not see "Test Email"

Scenario: Editing email template to have blank body or to field displays flash error
    Given I am on the email templates index
    And I follow "Welcome Email"
    And I fill in "email_template_to" with ""
    And I press "Submit"
    Then I should see "An error occured: To can't be blank"
    When I fill in TinyMCE email form with ""
    And I press "Submit"
    Then I should see "An error occured: Body can't be blank"
