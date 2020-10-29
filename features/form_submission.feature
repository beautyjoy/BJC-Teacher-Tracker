Feature: submit a form as a teacher

  As a teacher
  So that I can be added to the BJC program
  I want to be able to fill out a form on the BJC website

Scenario: Correctly filling out and succesful form submission
    Given I am on the BJC home page
    And   I enter my "First Name" as "Kimberly"
    And   I enter my "Last Name" as "Zhu"
    And   I enter my "School Email" as "kpzhu@berkeley.edu"
    And   I enter my "Snap! Username" as "kpzhu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I enter "More Information" as "I am after school volunteer"
    And   I enter my "Personal or Course Website" as "https://chs.fuhsd.org"
    And   I enter my "School Name" as "Cupertino High School"
    And   I enter my "City" as "Cupertino"
    And   I select "CA" from "State"
    And   I enter my "School Website" as "https://chs.fuhsd.org"
    And   I press "Submit"
    Then  I see a confirmation "Thanks for signing up for BJC"

Scenario: Filling a new form with existing info shows and updated confirmation.
    Given I am on the BJC home page
    And   I enter my "First Name" as "Kimberly"
    And   I enter my "Last Name" as "Zhu"
    And   I enter my "School Email" as "kpzhu@berkeley.edu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I enter my "School Name" as "Cupertino High School"
    And   I enter my "City" as "Cupertino"
    And   I select "CA" from "State"
    And   I enter my "School Website" as "https://chs.fuhsd.org"
    And   I press "Submit"
    Then  I see a confirmation "Thanks! We have updated your information."

Scenario: Not Correctly filling out and unsuccesful form submission
    Given I am on the BJC home page
    And   I enter my "First Name" as "Kimberly"
    And   I enter my "Last Name" as "Zhu"
    And   I set my status as "I am teaching BJC as an AP CS Principles course."
    And   I enter my "School Name" as "Cupertino High School"
    And   I enter my "City" as "Cupertino"
    And   I select "CA" from "State"
    And   I enter my "School Website" as "chs.fuhsd.org"
    And   I press "Submit"
    Then  The "#new_teacher" form is invalid
    And  I am on the BJC home page
