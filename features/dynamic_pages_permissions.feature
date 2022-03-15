Feature: dynamic pages features a verified teacher

    As a verifed teacher, I should only be able to see pages I have access to

Background: Has admin and teacher in DB along with pages of each permission type
    Given I seed data
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    | Todd       | Teacher   | false | testteacher@berkeley.edu     |
    Given the following dynamic pages exist:
    | slug | title | body | permissions                        |
    | test_slug_admin            | Test Admin Page   | Test admin body.   | Admin   |
    | test_slug_verified_teacher | Test Teacher Page | Test teacher body. | Verified Teacher |
    | test_slug_public           | Test Public Page  | Test public body.  | Public   |

Scenario: Admins can see everything
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    Given I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should see "Test Teacher Page"
    And I should see "Test Admin Page"
    And I should see "Edit"
    And I should see "Delete"
    And I should see "New Page"

Scenario: Teachers can't see admin pages or new page button
    Given I am on the BJC home page
    Given I have a teacher Google email
    And I follow "Log In"
    Then I can log in with Google
    Given I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should see "Test Teacher Page"
    And I should not see "Test Admin Page"
    And I should not see "Delete"
    And I should not see "New Page"

Scenario: Public can only see public pages
    Given I am on the BJC home page
    Given I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Test Public Page"
    And I should not see "Test Teacher Page"
    And I should not see "Test Admin Page"
    And I should not see "Delete"
    And I should not see "New Page"
