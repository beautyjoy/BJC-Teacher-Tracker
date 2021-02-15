Feature: basic admin functionality

  As an admin
  So that I can see how many people are teaching BJC
  I can login in an see the dashboard

Scenario: Logging in as an admin
  Given I am   on the BJC home page
  And I follow "Admin Log In"
  Then I can log in with Google
  And I should see "BJC Teacher Dashboard"
