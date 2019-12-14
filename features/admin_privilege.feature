Feature: Admin should be able to see unvalidated forms and statistics on validated forms

  As an admin 
  So that I can perform administrative tasks on the BJC app
  I want to be able to correctly view info about unvalidated and validated forms

Scenario: Upon submitting a new teacher form, the application should show up in the unvalidated forms table
    Given that I am on the home page and I have submitted a new form for "Varun Murthy" with Snap! username "murthy1999" to teach at "Berkeley High" in "Berkeley, CA"
    And I go to the admin page
    Then I should see "Varun Murthy" with Snap! username "murthy1999" in the unvalidated forms table

Scenario: Upon submitting two new teacher forms, the two applications should show up in the unvalidated forms table
    Given that I am on the home page and I have submitted a new form for "Varun Murthy" with Snap! username "murthy1999" to teach at "Berkeley High" in "Berkeley, CA"
    Given that I am on the home page and I have submitted a new form for "Dalton Surprenant" with Snap! username "" to teach at "Berkeley High" in "Berkeley, CA"
    And I go to the admin page
    Then I should see "Varun Murthy" with Snap! username "murthy1999" in the unvalidated forms table
    Then I should see "Dalton Surprenant" with Snap! username "" in the unvalidated forms table