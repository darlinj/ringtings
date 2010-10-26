Feature: Homepage checks

  Scenario: Basic checks
    When I go to the homepage
    Then I should see "telephone system"

  Scenario: Create user
    Given I sign out
    And there is no user with ID "joe@somewhere.com"
    When I go to the sign up page
    And I type "joe@somewhere.com" in the form field with an HTML id of "user_email"
    And I type "password" in the form field with an HTML id of "user_password"
    And I type "password" in the form field with an HTML id of "user_password_confirmation"
    And I press "Sign up"
    Then I should see "instructions for confirming"
    And I confirm the user "joe@somewhere.com"
    When I go to the sign in page
    And I type "joe@somewhere.com" in the form field with an HTML id of "session_email"
    And I type "password" in the form field with an HTML id of "session_password"
    And I press "Sign in"
    Then I should see "Signed in"

  Scenario: Accessing restricted data
    Given I am signed up and confirmed as "joe@foo.com/password"
    And I sign out
    When I go to a restricted page
    Then I should see "Sign in"

  Scenario: logging in from the homepage
    Given I sign out
    And I am signed up and confirmed as "joe@foo.com/password"
    When I go to the homepage
    And I type "joe@foo.com" in the form field with an HTML id of "breadcrumbs_email"
    And I type "password" in the form field with an HTML id of "breadcrumbs_password"
    And I press "Go"
    Then I should see "Signed in"
    When I go to the homepage
    Then I should see "Welcome joe@foo.com"
    When I follow "log out"
    Then I should see "Signed out"
    And I should be on the homepage
    And I should see "login"

