Feature: Managing personal email addresses for teachers

  Background:
  Background: Has an Admin in DB
    Given the following teachers exist:
      | first_name | last_name | admin | primary_email            |
      | Admin    | User    | true  | testadminuser@berkeley.edu   |
    Given the following schools exist:
      |       name      |     country     |     city     |  state  |            website            |  grade_level  |  school_type  |
      |   UC Berkeley   |       US        |   Berkeley   |   CA    |   https://www.berkeley.edu    |  university   |     public    |
    Given the following teachers exist:
      | first_name | last_name | admin | primary_email            | school      | snap   | application_status |
      | Joseph     | Mamoa     | false | jose.primary@email.com | UC Berkeley | false |    Validated       |
    Given the following emails exist:
      | first_name | last_name | email                    | primary |
      | Joseph     | Mamoa     | jose.personal1@email.com | false   |
      | Joseph     | Mamoa     | jose.personal2@email.com | false   |


  Scenario: Admin views teacher personal emails
    Given I am on the BJC home page
    And I have an admin email
    And   I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    Then I should see "Admin View Joseph Mamoa"
    Then I should see "jose.personal1@email.com"
    Then I should see "jose.personal2@email.com"
    Then I should see "Edit Personal Emails"

  Scenario: Admin adds a personal email address to a teacher
    Given I am on the BJC home page
    And I have an admin email
    And   I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    And I follow "Edit Personal Emails"
    And I follow "Add Email"
    And I fill in "teacher[email_addresses_attributes][2][email]" with "jose.personal3@email.com"
    And I press "Update Emails"
    Then I should see a "info" flash message "Personal email addresses updated successfully."
    Then I should see "Admin View Joseph Mamoa"
    Then I should see "jose.personal3@email.com"

  Scenario: Admin updates an existing personal email address
    Given I am on the BJC home page
    And I have an admin email
    And   I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    And I follow "Edit Personal Emails"
    And I fill in "teacher[email_addresses_attributes][1][email]" with "jose.personalxxxxxx@email.com"
    And I press "Update Emails"
    Then I should see a "info" flash message "Personal email addresses updated successfully."
    Then I should not see "jose.personal2@email.com"
    And I should see "jose.personal1@email.com"
    And I should see "jose.personalxxxxxx@email.com"

  Scenario: Admin deletes a personal email address
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    And I follow "Edit Personal Emails"
    And I press "Remove" next to "jose.personal1@email.com"
    And I press "Update Emails"
    Then I should see a "info" flash message "Personal email addresses updated successfully."
    Then I should not see "jose.personal1@email.com"
    And I should see "jose.personal2@email.com"

  Scenario: Admin tries to add an existing personal email address to the same teacher
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    And I follow "Edit Personal Emails"
    And I follow "Add Email"
    And I fill in "teacher[email_addresses_attributes][2][email]" with "jose.personal1@email.com"
    And I press "Update Emails"
    Then I should see a "danger" flash message "An error occurred: Email has already been taken"

  Scenario: Admin tries to add an email that exists for another teacher
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I follow "Teachers"
    And I follow "Joseph Mamoa"
    And I follow "Edit Personal Emails"
    And I fill in "teacher[email_addresses_attributes][0][email]" with "testadminuser@berkeley.edu"
    And I press "Update Emails"
    Then I should see a "danger" flash message "An error occurred: Email has already been taken"
