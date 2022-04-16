Feature: dynamic pages features as an admin

    As an admin, I should be able to create, view, and edit dynamic pages

Background: I am logged in as an admin
    Given I seed data
    Given the following teachers exist:
    | first_name | last_name | admin | email                        |
    | Joseph     | Mamoa     | true  | testadminuser@berkeley.edu   |
    Given I am on the BJC home page
    Given I have an admin email
    And I follow "Log In"
    Then I can log in with Google
    And I should see "BJC Teacher Dashboard"

Scenario: Pressing "Dynamic Pages" button on navbar should take me to a list of all dynamic pages
    Given I follow "Pages"
    Then I should be on the dynamic pages index
    And I should see "Title"
    And I should see "Permissions"
    And I should not see "Body"

Scenario: Pressing "New Page" button should take user to new page form
    Given I am on the dynamic pages index
    And I press "New Page"
    Then I should be on the new dynamic pages page
    And I should see "Title"
    And I should see "Slug"
    And I should see "Body"

Scenario: Successfully creating a new dynamic page redirects to that page
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I fill in the dynamic_page_body with "This is a test"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then I should see "Test Title"
    Then I should see "This is a test"

Scenario: Creating a page without a title fails
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then The "#new_dynamic_page" form is invalid
    And I should be on the new dynamic pages page

Scenario: Creating a page without a slug fails
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then The "#new_dynamic_page" form is invalid
    And I should be on the new dynamic pages page

Scenario: Creating a page without choosing permissions fails
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    Then The "#new_dynamic_page" form is invalid
    And I should be on the new dynamic pages page

Scenario: I create a new page and I can see it on the index page
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    Then I should see "Test Title"
    And I should see "Admin"

Scenario: Can create a new page with the same title as a page that already exists
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    And I press "New Page"
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug_2"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then I should see "Test Title"

Scenario: Can't create a page with a slug that already exists
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    And I press "New Page"
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then I should be on the new dynamic pages page

Scenario: Attempting to create page with taken slug doesn't delete form input
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I fill in the dynamic_page_body with "Don't see this"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    And I press "New Page"
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I fill in the dynamic_page_body with "This is a test"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    Then I should be on the new dynamic pages page
    And the "dynamic_page_title" field should contain "Test Title"
    And the "dynamic_page_slug" field should contain "test_slug"
    And I should see "This is a test"
    And I should not see "Don't see this"

Scenario: I can delete pages
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    When I press the delete button for "test_slug"
    Then I should not see "test_slug"

Scenario: Can create pages with any selection for permissions
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Admin Permissions"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    And I press "New Page"
    And I fill in "dynamic_page_title" with "Verified Teacher Permissions"
    And I fill in "dynamic_page_slug" with "test_slug_2"
    And I choose "inlineRadioTeacher"
    And I press "Submit"
    And I follow "Pages"
    And I press "New Page"
    And I fill in "dynamic_page_title" with "Public Permissions"
    And I fill in "dynamic_page_slug" with "test_slug_3"
    And I choose "inlineRadioPublic"
    And I press "Submit"

Scenario: Correctly store user's full name and create date.
    Given I am on the dynamic pages index
    And I press "New Page"
    Then I should be on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test page"
    And I fill in "dynamic_page_slug" with "Test"
    And I choose "inlineRadioAdmin"
    And I press "Submit"
    And I follow "Pages"
    And I should see "Joseph Mamoa"

Scenario: Can edit pages with correct prefilled content in the form.
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I fill in the dynamic_page_body with "This is a test"
    And I press "Submit"
    And I follow "Pages"
    And I press the edit button for "test_slug"
    Then I should be on the edit dynamic pages page for "test_slug"
    And the "dynamic_page_title" field should contain "Test Title"
    And the "dynamic_page_slug" field should contain "test_slug"
    And I should see "This is a test"
    Then I fill in "dynamic_page_title" with "New Title"
    And I fill in "dynamic_page_slug" with "new_slug"
    And I choose "inlineRadioPublic"
    And I fill in the dynamic_page_body with "This is a test 2"
    And I press "Update"
    Then I should see "New Title"
    And I should see "Public"
    Then I should be on the dynamic pages index
    And I should not see "Test Title"
    And I should not see "test_slug"

Scenario: Can update page even if no changes
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I fill in the dynamic_page_body with "This is a test"
    And I press "Submit"
    And I follow "Pages"
    And I press the edit button for "test_slug"
    Then I should be on the edit dynamic pages page for "test_slug"
    And I press "Update"
    Then I should be on the dynamic pages index
    And I should see "Test Title"
    And I should see "Admin"

Scenario: Attempting to update page with taken slug doesn't delete form input
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I choose "inlineRadioAdmin"
    And I fill in the dynamic_page_body with "This is a test"
    And I press "Submit"
    Given I am on the new dynamic pages page
    And I fill in "dynamic_page_title" with "Test Title 2"
    And I fill in "dynamic_page_slug" with "test_slug_2"
    And I choose "inlineRadioAdmin"
    And I fill in the dynamic_page_body with "This is a test"
    And I press "Submit"
    Then I follow "Pages"
    And I press the edit button for "test_slug_2"
    Then I should be on the edit dynamic pages page for "test_slug_2"
    And I fill in "dynamic_page_title" with "New Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I fill in the dynamic_page_body with "New page body."
    And I press "Update"
    Then I should be on the edit dynamic pages page for "test_slug_2"
    And the "dynamic_page_title" field should contain "New Title"
    And the "dynamic_page_slug" field should contain "test_slug"
    And I should see "New page body."

Scenario: Clicking radio button text selects that radio button
    Given I am on the new dynamic pages page
    And I choose "Admin"
    Then The radio button "inlineRadioAdmin" should be checked
    And I choose "Verified Teacher"
    Then The radio button "inlineRadioTeacher" should be checked
    And I choose "Public"
    Then The radio button "inlineRadioPublic" should be checked