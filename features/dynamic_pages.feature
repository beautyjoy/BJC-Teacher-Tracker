Feature: dynamic pages features

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
    Given I follow "Dynamic Pages"
    Then I should be on the dynamic pages index
    And I should see "Title"
    And I should see "Slug"
    And I should not see "Body"

Scenario: Pressing "Add New Page" button should take user to new page form
    Given I am on the dynamic pages index
    And I press "Add New Page"
    Then I should be on the dynamic pages new
    And I should see "Title"
    And I should see "Slug"
    And I should see "Body"

Scenario: Successfully creating a new dynamic page redirects to that page
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    Then I should see "Test Title"

Scenario: Creating a page without a title fails
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    Then The "#new_dynamic_page" form is invalid
    And I should be on the dynamic pages new

Scenario: Creating a page without a slug fails
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_title" with "Test Title"
    And I press "Submit"
    Then The "#new_dynamic_page" form is invalid
    And I should be on the dynamic pages new

Scenario: I create a new page and I can see it on the index page
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    And I follow "Dynamic Pages"
    Then I should see "Test Title"
    And I should see "test_slug"

Scenario: Can create a new page with the same title as a page that already exists
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    And I follow "Dynamic Pages"
    And I press "Add New Page"
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug_2"
    And I press "Submit"
    Then I should see "Test Title"

Scenario: (Prob need to edit this later) Can't create a page with a slug that already exists
    Given I am on the dynamic pages new
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    And I follow "Dynamic Pages"
    And I press "Add New Page"
    And I fill in "dynamic_page_title" with "Test Title"
    And I fill in "dynamic_page_slug" with "test_slug"
    And I press "Submit"
    Then I should be on the dynamic pages new
  Scenario: Can delete a page
  Scenario: I create a new page and I can see it on the index page
      Given I am on the dynamic pages new
      And I fill in "dynamic_page_title" with "Test Title"
      And I fill in "dynamic_page_slug" with "test_slug"
      And I press "Submit"
      And I follow "Dynamic Pages"
      When I press "Delete" button for "test_slug"
      Then I should not see "test_slug"
