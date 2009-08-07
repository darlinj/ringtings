@e2e
Story: Homepage checks

  Scenario: Basic checks
    When I go to the homepage
    Then I should see "Playpen title"
    Then I should see "Menu"
    Then I should see "This is the playpen main site"
    Then I should see "Footer"

  Scenario: Create user
    Given I am logged out
    And there is no user with ID "joe@somewhere.com"
    When I go to the sign up page
    And I fill in "Email" with "joe@somewhere.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm password" with "password"
    And I press the submit button
    Then I should see "instructions for confirming"
    And I confirm the user "joe@somewhere.com"
    When I go to the sign in page
    When I fill in "Email" with "joe@somewhere.com"
    And I fill in "Password" with "password"
    And I click on "login"
    Then I should see "Welcome joe@somewhere.com"

  Scenario: Accessing restricted data when not logged in
    Given I am logged out
    When I follow "restricted content"
    Then I should see "To access this page you need to be logged in"

    When I fill in "login" with "joe"
    And I fill in "password" with "pa55word"
    And I click on "login"
    Then I should see "Welcome Joe Darling"

    When I follow "restricted content"
    Then I should see "Here is your restricted content.  Exciting isn't it!"

