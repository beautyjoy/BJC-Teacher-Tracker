Feature: dynamic pages features a verified teacher

    As a verifed teacher, I should only be able to see pages I have access to

Background: Has admin and teacher in DB along with pages of each permission type
    Given I seed data
    Given the following teachers exist:
    | first_name | last_name | admin | email                        | application_status |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   | Pending            |
    | Todd       | Teacher   | false | testteacher@berkeley.edu     | Validated          |
    Given the following dynamic pages exist:
    | slug                       | title             | body               | permissions      |
    | test_slug_admin            | Test Admin Page   | Test admin body.   | Admin            |
    | test_slug_verified_teacher | Test Teacher Page | Test teacher body. | Verified Teacher |
    | test_slug_public           | Test Public Page  | Test public body.  | Public           |

Scenario: Admins can see everything
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should see "Test Teacher Page"
    And I should see "Test Admin Page"
    And I should see "Edit"
    And I should see "Delete"
    And I should see a button named "Delete"
    And I should see a button named "Edit"
    And I should see a button named "New Page"

Scenario: Teachers can't see admin pages, edit/delete button, or new page button
    Given I am on the BJC home page
    Given I have a teacher Google email
    And I follow "Log In"
    Then I can log in with Google
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should see "Test Teacher Page"
    And I should not see "Test Admin Page"
    And I should not see "Delete"
    And I should not see a button named "Delete"
    And I should not see a button named "Edit"
    And I should not see a button named "New Page"

Scenario: Public can only see public pages
    Given I am on the BJC home page
    Given I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should not see "Test Teacher Page"
    And I should not see "Test Admin Page"
    And I should not see "Delete"
    And I should not see a button named "Delete"
    And I should not see a button named "Edit"
    And I should not see a button named "New Page"

Scenario: Admin can access all pages
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Public Page"
    Then I should be on the dynamic page for slug "test_slug_public"
    And I should see "Test Public Page"
    And I should see "Test public body."
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Teacher Page"
    Then I should be on the dynamic page for slug "test_slug_verified_teacher"
    And I should see "Test Teacher Page"
    And I should see "Test teacher body."
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Admin Page"
    Then I should be on the dynamic page for slug "test_slug_admin"
    And I should see "Test Admin Page"
    And I should see "Test admin body."

Scenario: Teachers can access public pages
    Given I am on the BJC home page
    Given I have a teacher Google email
    And I follow "Log In"
    Then I can log in with Google
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Public Page"
    Then I should be on the dynamic page for slug "test_slug_public"
    And I should see "Test Public Page"
    And I should see "Test public body."

Scenario: Teachers can access teacher pages
    Given I am on the BJC home page
    Given I have a teacher Google email
    And I follow "Log In"
    Then I can log in with Google
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Teacher Page"
    Then I should be on the dynamic page for slug "test_slug_verified_teacher"
    And I should see "Test Teacher Page"
    And I should see "Test teacher body."

Scenario: Public can access public pages
    Given I am on the BJC home page
    Then I follow "Pages"
    Then I should be on the dynamic pages index
    And I follow "Test Public Page"
    Then I should be on the dynamic page for slug "test_slug_public"
    And I should see "Test Public Page"
    And I should see "Test public body."