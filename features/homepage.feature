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
    And I click on "Sign in"
    Then I should see "Signed in"

  Scenario: Accessing restricted data when not logged in
    Given there is a validated user with email "joe@foo.com" and a passord of "password"
    Given I am logged out
    When I go to a restricted page
    Then I should see "Sign in"

    When I fill in "Email" with "joe@somewhere.com"
    And I fill in "Password" with "password"
    And I click on "Sign in"
    Then I should see "Signed in"

    Then I should see "Here is your restricted content. Exciting isn't it!"

