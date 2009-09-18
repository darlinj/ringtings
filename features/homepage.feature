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
    And I type "joe@somewhere.com" in the form field with an HTML id of "user_email"
    And I type "password" in the form field with an HTML id of "user_password"
    And I type "password" in the form field with an HTML id of "user_password_confirmation"
    And I click on "Sign up"
    Then I should see "instructions for confirming"
    And I confirm the user "joe@somewhere.com"
    When I go to the sign in page
    And I type "joe@somewhere.com" in the form field with an HTML id of "session_email"
    And I type "password" in the form field with an HTML id of "session_password"
    And I click on "Sign in"
    Then I should see "Signed in"

  Scenario: Accessing restricted data 
    Given there is a validated user with email "joe@foo.com" and a passord of "password"
    And I am logged out
    When I go to a restricted page
    Then I should see "Sign in"

    And I type "joe@somewhere.com" in the form field with an HTML id of "session_email"
    And I type "password" in the form field with an HTML id of "session_password"
    And I click on "Sign in"
    Then I should see "Signed in"

    Then I should see "Here is your restricted content. Exciting isn't it!"

  Scenario: logging in from the homepage
    Given I am logged out
    When I go to the homepage
    And I type "joe@somewhere.com" in the form field with an HTML id of "breadcrumbs_email"
    And I type "password" in the form field with an HTML id of "breadcrumbs_password"
    And I click on "Go" 
    Then I should see "Signed in"
    When I go to the homepage
    Then I should see "Welcome joe@somewhere.com"
    When I follow "log out"
    Then I should see "Signed out"
    And I should be on the homepage
    And I should see "login"

