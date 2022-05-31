Feature: submit a form as a teacher

  As a teacher
  So that I can be added to the BJC program
  I want to be able to fill out a form on the BJC website

Background: Test Data
    Given a valid teacher exists
    Given I seed data

Scenario: Correctly filling out and succesful form submission
    Given "kpzhu@berkeley.edu" is not in the database
    Given I am on the BJC home page
    And   I enter my "First Name" as "Kimberly"
    And   I enter my "Last Name" as "Zhu"
    And   I enter my "School Email" as "TESTkpzhu@berkeley.edu"
    And   I enter my "Snap! Username" as "kpzhu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I set my education level target as "High School"
    And   I fill in "More Information" with "I am after school volunteer"
    And   I enter my "Personal or Course Website" as "https://chs.fuhsd.org"
    And   I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
    And   I enter my "City" as "Cupertino"
    And   I select "CA" from "State"
    And   I enter my "School Website" as "https://chs.fuhsd.org"
    And   I select "University" from "Grade Level"
    And   I select "Public" from "School Type"
    And   I press "Submit"
    Then  I see a confirmation "Thanks for signing up for BJC"

Scenario: Not Correctly filling out and unsuccesful form submission
    Given I am on the BJC home page
    And   I enter my "First Name" as "Kimberly"
    And   I enter my "Last Name" as "Zhu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
    And   I enter my "City" as "Cupertino"
    And   I select "CA" from "State"
    And   I enter my "School Website" as "chs.fuhsd.org"
    And   I select "University" from "Grade Level"
    And   I select "Public" from "School Type"
    And   I press "Submit"
    Then  The "#new_teacher" form is invalid
    And  I am on the BJC home page

Scenario: Websites validation - two invalid websites
    Given I am on the BJC home page
    And I enter my "First Name" as "Jonathan"
    And I enter my "Last Name" as "Cena"
    And I enter my "School Email" as "jonathancena@wwe.com"
    And I enter my "Personal or Course Website" as "jonathancenacom"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Stafford High School" and choose to add a new school
    And I enter my "City" as "Palo Alto"
    And I select "CA" from "State"
    And I enter my "School Website" as "stafford"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then The "#new_teacher" form is invalid
    And  I am on the BJC home page

Scenario: Websites validation - one invalid website
    Given I am on the BJC home page
    And I enter my "First Name" as "Jonathan"
    And I enter my "Last Name" as "Cena"
    And I enter my "School Email" as "jonathancena@wwe.com"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Stafford High School" and choose to add a new school
    And I enter my "City" as "Palo Alto"
    And I select "CA" from "State"
    And I enter my "School Website" as "stafford"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then The "#new_teacher" form is invalid
    And  I am on the BJC home page

Scenario: Websites validation - one valid website
    Given I am on the BJC home page
    And I enter my "First Name" as "Jonathan"
    And I enter my "Last Name" as "Cena"
    And I enter my "School Email" as "jonathancena@wwe.com"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Stafford High School" and choose to add a new school
    And I enter my "City" as "Palo Alto"
    And I select "CA" from "State"
    And I enter my "School Website" as "https://stafford.edu"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then I see a confirmation "Thanks for signing up for BJC"

Scenario: Filling out new form with existing email should not update information
    Given the following teachers exist:
    | first_name | last_name | admin | email              |
    | Alice      | Adams     | false | alice@berkeley.edu |
    And I am on the BJC home page
    And I enter my "First Name" as "Mallory"
    And I enter my "Last Name" as "Moore"
    And I enter my "School Email" as "alice@berkeley.edu"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
    And I enter my "City" as "Cupertino"
    And I select "CA" from "State"
    And I enter my "School Website" as "https://chs.fuhsd.org"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then I should see "Email has already been taken"
    Then the "first_name" of the user with email "alice@berkeley.edu" should be "Alice"

Scenario: Filling out new form with existing Snap should not create new teacher
    Given the following teachers exist:
    | first_name | last_name | admin | email              | snap       |
    | Alice      | Adams     | false | alice@berkeley.edu | aliceadams |
    And I am on the BJC home page
    And I enter my "First Name" as "Mallory"
    And I enter my "Last Name" as "Moore"
    And I enter my "School Email" as "mallory@berkeley.edu"
    And I enter my "Snap! Username" as "aliceadams"
    And I set my status as "I am teaching BJC as an AP CS Principles course."
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Cupertino High School" and choose to add a new school
    And I enter my "City" as "Cupertino"
    And I select "CA" from "State"
    And I enter my "School Website" as "https://chs.fuhsd.org"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"
    Then I should see "Email address or Snap username already in use."
    And "mallory@berkeley.edu" is not in the database

Scenario: Filling out form should have the correct information in a Teacher
    Given "bbaker@berkeley.edu" is not in the database
    And I am on the BJC home page
    And I enter my "First Name" as "Bob"
    And I enter my "Last Name" as "Baker"
    And I enter my "School Email" as "bbaker@berkeley.edu"
    And I enter my "Personal or Course Website" as "https://www.bobbaker.io"
    And I enter my "Snap! Username" as "bbbbbaker"
    And I set my status as "I am teaching BJC through the TEALS program."
    And I fill in "More Information" with "I am a TEALS program employee!"
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Castro Valley High School" and choose to add a new school
    And I enter my "City" as "Castro Valley"
    And I select "CA" from "State"
    And I enter my "School Website" as "cvhs.cv.k12.ca.us"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"

    Then the "first_name" of the user with email "bbaker@berkeley.edu" should be "Bob"
    Then the "last_name" of the user with email "bbaker@berkeley.edu" should be "Baker"
    Then the "snap" of the user with email "bbaker@berkeley.edu" should be "bbbbbaker"
    Then the "status" of the user with email "bbaker@berkeley.edu" should be "teals_teacher"
    Then the "more_info" of the user with email "bbaker@berkeley.edu" should be "I am a TEALS program employee!"
    Then the "personal_website" of the user with email "bbaker@berkeley.edu" should be "https://www.bobbaker.io"
    Then the "education_level" of the user with email "bbaker@berkeley.edu" should be "high_school"

  Scenario: Filling out the form with correct information as a host
    Given "bbaker@berkeley.edu" is not in the database
    And I am on the BJC home page
    And I enter my "First Name" as "Bob"
    And I enter my "Last Name" as "Baker"
    And I enter my "School Email" as "bbaker@berkeley.edu"
    And I enter my "Personal or Course Website" as "https://www.bobbaker.io"
    And I enter my "Snap! Username" as "bbbbbaker"
    And I set my status as "I am a TEALS volunteer, and am teaching the BJC curriculum."
    Then I should not see "ex. Im teaching a college course"
    And I fill in "More Information" with "Rebecca"
    And I set my education level target as "High School"
    And I fill in the school name selectize box with "Castro Valley High School" and choose to add a new school
    And I enter my "City" as "Castro Valley"
    And I select "CA" from "State"
    And I enter my "School Website" as "cvhs.cv.k12.ca.us"
    And I select "University" from "Grade Level"
    And I select "Public" from "School Type"
    And I press "Submit"

    Then the "first_name" of the user with email "bbaker@berkeley.edu" should be "Bob"
    Then the "last_name" of the user with email "bbaker@berkeley.edu" should be "Baker"
    Then the "snap" of the user with email "bbaker@berkeley.edu" should be "bbbbbaker"
    Then the "status" of the user with email "bbaker@berkeley.edu" should be "teals_volunteer"
    Then the "more_info" of the user with email "bbaker@berkeley.edu" should be "Rebecca"
    Then the "personal_website" of the user with email "bbaker@berkeley.edu" should be "https://www.bobbaker.io"
    Then the "education_level" of the user with email "bbaker@berkeley.edu" should be "high_school"

Scenario: Teachers creating their account should not be able to input Tags or NCES ID for their school.
    Given I am on the BJC home page
    Then I should not see "Tags"
    And I should not see "NCIS ID"