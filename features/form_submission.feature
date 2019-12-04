Feature: submit a form as a teacher

  As a teacher 
  So that I can be added to the BJC program
  I want to be able to fill out a form on the BJC website

Scenario: Correctly filling out and succesful form submission
    Given I am on the BJC home page
    And   I enter my "first name" as "Kimberly"
    And   I enter my "last name" as "Zhu"
    And   I enter my "email" as "kpzhu@berkeley.edu"
    And   I enter my "snap username" as "n/a"
    And   I select "I am teaching BJC as an AP CS Principles course." from "course" 
    And   I enter my "other" as "n/a"
    And   I enter my "school name" as "Cupertino High School"
    And   I enter my "school city" as "Cupertino"
    And   I select "CA" from "state" 
    And   I enter my "school website" as "chs.fuhsd.org"

    And   I press "Submit"
    Then  I see a confirmation "Thanks for signing up!" 

Scenario: Not Correctly filling out and unsuccesful form submission
    Given I am on the BJC home page
    And   I enter my "first name" as "Kimberly"
    And   I enter my "last name" as "Zhu"
    And   I press "Submit"
    Then  I should be on the BJC home page