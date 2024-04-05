Feature: Professional Development and Registration Management

  As an admin or a teacher
  I want to manage professional development events and registrations
  So that I can organize and track participation in PD activities

  Background: Admin and Teacher exist
    Given the following teachers exist:
      | first_name | last_name | admin | email                        | id   |
      | Perry      | Zhong     | true  | testadminuser@berkeley.edu   | 100  |
      | Joseph     | Mamoa     | false | testteacher@berkeley.edu     | 101  |
    And the following professional developments exist:
      | id  | name                     | city          | state | country      | start_date | end_date   | grade_level | created_at          | updated_at          |
      | 10  | Classroom Management     | San Francisco | CA    | United States| 2023-02-01 | 2023-02-05 | university  | 2023-02-01 00:00:00 | 2023-02-01 00:00:00 |
      | 11  | Teaching Strategies      | San Francisco | CA    | United States| 2023-01-01 | 2023-01-05 | university  | 2023-01-01 00:00:00 | 2023-01-01 00:00:00 |

#  Basic CRUD operations for Professional Developments
  Scenario: Admin creates a new Professional Development
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then  I should see "New Requests"
    Then  I go to the new professional development page
    Then  I should see "Create a new Professional Development"
    And I fill in "Professional Development Name" with "Innovative Teaching Techniques"
    And I fill in "City" with "San Francisco"
    And I select "CA" from "State" dropdown
    And I select "United States" from "Country"
    And I fill in "Start Date" with "2023-12-01"
    And I fill in "End Date" with "2023-12-05"
    And I select "University" from "Grade Level"
    And I press "Submit"
    Then I should see a "info" flash message "Professional development created successfully."
    And I should arrive at the professional development show page titled "Innovative Teaching Techniques"

  Scenario: Admin updates a Professional Development
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the professional developments page
#   first "Edit" link is for the Classroom Management, due to alphabetical order in the table
    And I follow the first "Edit" link
    And I fill in "Professional Development Name" with "Classroom Management 2.0"
    And I press "Submit"
    Then I should see a "info" flash message "Professional development updated successfully."
    And I should arrive at the professional development show page titled "Classroom Management 2.0"

  Scenario: Admin deletes a Professional Development with confirmation
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the professional developments page
    And I should see "Classroom Management"
    Then I follow the first "❌" link
    And I confirm the action
    Then I should see a "info" flash message "Professional development deleted successfully."
    And I should be on the professional developments page
    And I should not see "Classroom Management"

  Scenario: Admin deletes a Professional Development without confirmation
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the professional developments page
    And I should see "Classroom Management"
    Then I follow the first "❌" link
    And I dismiss the action
    And I should be on the professional developments page
    And I should see "Classroom Management"

  Scenario: Admin registers a teacher for a Professional Development
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I go to the professional developments page
    And I should see "Classroom Management"
    And I follow the first "Classroom Management" link
    Then I should see "Classroom Management"
    Then I press "Add Registration"
    Then I should see "Add Teacher to PD Session"
    And I fill in "Teacher ID" with "100"
    And I select "Attendee" from "Role"
    And I select "Yes" from "Attended"
    And I press "Add"
    Then I should see a "info" flash message "Registration for professional development was successfully created."
    And I should see "Total Registered Teachers: 1"
    And I should see "Perry Zhong"

# Basic CRUD operations for Professional Development Registrations
  Scenario: Admin updates a teacher's registration for a Professional Development
    Given the following professional developments registrations exist
      | id | professional_development_id | teacher_id | role     | attended | created_at          | updated_at          |
      | 1  | 10                          | 100        | attendee | yes      | 2023-02-01 00:00:00 | 2023-02-01 00:00:00 |
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I go to the professional developments page
    And I should see "Classroom Management"
    And I follow the first "Classroom Management" link
    Then I should see "Classroom Management"
    And I should see "Total Registered Teachers: 1"
    And I should see "Perry Zhong"
    And I should see "Yes"
    And I follow "Update"
    Then I should see "Edit Teacher in PD Session"
    Then I select "No" from "Attended"
    And I press "Add"
    Then I should see a "info" flash message "Registration was successfully updated."
    And I should see "Perry Zhong"
    And I should see "No"
    And I should not see "Yes"

  Scenario: Admin cancels a teacher's registration for a Professional Development
    Given the following professional developments registrations exist
      | id | professional_development_id | teacher_id | role     | attended | created_at          | updated_at          |
      | 1  | 10                          | 100        | attendee | yes      | 2023-02-01 00:00:00 | 2023-02-01 00:00:00 |
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I go to the professional developments page
    And I should see "Classroom Management"
    And I follow the first "Classroom Management" link
    Then I should see "Classroom Management"
    And I should see "Total Registered Teachers: 1"
    And I should see "Perry Zhong"
    And I should see "Yes"
    And I follow "❌"
    And I confirm the action
    Then I should see a "info" flash message "Registration was successfully cancelled."
    And I should see "Total Registered Teachers: 0"
    And I should not see "Perry Zhong"
    And I should not see "Yes"

# Advanced scenarios for Professional Development and Registration Management
  Scenario: Admin creates a duplicate Professional Development registration should fail
    Given the following professional developments registrations exist
      | id | professional_development_id | teacher_id | role     | attended | created_at          | updated_at          |
      | 1  | 10                          | 100        | attendee | yes      | 2023-02-01 00:00:00 | 2023-02-01 00:00:00 |
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    When I go to the professional developments page
    And I follow the first "Classroom Management" link
    And I should see "Total Registered Teachers: 1"
    And I press "Add Registration"
    And I fill in "Teacher ID" with "100"
    And I select "Attendee" from "Role"
    And I select "Yes" from "Attended"
    And I press "Add"
    Then I should see a "danger" flash message "Teacher already has a registration for this PD"
    And I should see "Total Registered Teachers: 1"

  Scenario: Admin attempts to create a Professional Development with an end date earlier than the start date
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I should see "New Requests"
    Then I go to the new professional development page
    Then I should see "Create a new Professional Development"
    And I fill in "Professional Development Name" with "Future Educational Strategies"
    And I fill in "City" with "Los Angeles"
    And I select "CA" from "State" dropdown
    And I select "United States" from "Country"
    And I fill in "Start Date" with "2023-10-01"
    And I fill in "End Date" with "2023-09-30"
    And I select "High School" from "Grade Level"
    And I press "Submit"
    Then I should see a "danger" flash message "End date must be after the start date"
    And I should see "Add a Professional Development Workshop"

  Scenario: Admin attempts to create a Professional Development without mandatory fields
    Given I am on the BJC home page
    And I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I should see "New Requests"
    Then I go to the new professional development page
    Then I should see "Add a Professional Development Workshop"
    And I press "Submit"
    Then I should be on the new professional development page
    And I should see "Add a Professional Development Workshop"
