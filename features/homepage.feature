Story: Homepage checks

  Scenario: Basic checks
    When I go to the homepage
    Then I should see "Playpen title"
    Then I should see "Menu"
    Then I should see "This is the playpen main site"
    Then I should see "Footer"

    Given I am logged out
    When I follow "restricted content"
    Then I should see "To access this page you need to be logged in"

    When I fill in "login" with "joe"
    And I fill in "password" with "pa55word"
    And I click on "login"
    Then I should see "Welcome Joe Darling"

    When I follow "restricted content"
    Then I should see "Here is your restricted content.  Exciting isn't it!"

