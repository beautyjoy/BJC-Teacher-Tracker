Feature: access control for new users or non-admin users
  As an teacher or new user
  So that I can use the site as intended
  I cannot access pages for admins

Background: Has an Admin and a teacher in DB
  Given the following teachers exist:
  | first_name | last_name | admin  | primary_email               |
  | Alice      | Admin     | true   | testadminuser@berkeley.edu |
  | Todd       | Teacher   | false  | testteacher@berkeley.edu   |

# Logged-in Teacher (non-admin)
Scenario: Schools page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the schools page
  Then I should be on the edit page for Todd Teacher

Scenario: Dashboard page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the admin dashboard
  Then I should be on the edit page for Todd Teacher

Scenario: New School page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the new schools page
  Then I should be on the edit page for Todd Teacher

Scenario: All teacher page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the teachers page
  Then I should be on the edit page for Todd Teacher

Scenario: Email templates page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the email templates index
  Then I should be on the edit page for Todd Teacher

Scenario: Other user's edit page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the edit page for Alice Admin
  Then I should be on the edit page for Todd Teacher

Scenario: Other user's show page as a Teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  Given I am on the show page for Alice Admin
  Then I should be on the edit page for Todd Teacher

Scenario: Try to access merge page as a registered teacher
  Given I have a teacher Google email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  When I go to the merge preview page for Todd into Alice
  Then I should see "Only admins can access this page"

#New User
Scenario: Schools page as a new user
  Given I am on the schools page
  Then I should be on the new teachers page

Scenario: Dashboard page as a new user
  Given I am on the admin dashboard
  Then I should be on the new teachers page

Scenario: New School page as a new user
  Given I am on the new schools page
  Then I should be on the new teachers page

Scenario: All teacher page as a new user
  Given I am on the teachers page
  Then I should be on the new teachers page

Scenario: Email templates page as a new user
  Given I am on the email templates index
  Then I should be on the new teachers page

Scenario: admin user's edit page as a new user
  Given I am on the edit page for Alice Admin
  Then I should be on the new teachers page

Scenario: admin user's show page as a new user
  Given I am on the show page for Alice Admin
  Then I should be on the new teachers page

Scenario: Other user's edit page as a new user
  Given I am on the edit page for Todd Teacher
  Then I should be on the new teachers page

Scenario: Other user's show page as a new user
  Given I am on the show page for Todd Teacher
  Then I should be on the new teachers page
