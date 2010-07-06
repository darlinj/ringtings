Feature: Try it out page
  Scenario: trying the service
    Given I sign out
    And we clear the "InboundNumberManager" model
    And and "012345678901" is stored in the "inbound_number_manager" table in the database
    When I go to the homepage
    And I fill in "Company name" with "Mr Plumb the plumber"
    And I fill in "Phone number" with "09876543210"
    When I click the form input with id "next_submit_image"
    And I should see "Here is your first callplan"
    Then I should see "Ring 012345678901"
    Then I should see "please create a free account"
    Given I fill in "Email" with "plumb@plumber.com"
    When I fill in "Password" with "Password"
    And I fill in "Confirm password" with "Password"
    When I click the form input with id "next_submit_image"
    Then I should see "You will receive an email within the next few minutes. It contains instructions for confirming your account."
    And I should see "Well you can start editing your callplan to you own needs"
    When  a client requests POST /freeswitch/callplan with:
          | name                      | value         |
          | Caller-Destination-Number | 012345678901  |
    Then the xml node "//action/@application" should be "ivr"
    Then the xml node "//action/@data" should be "ivr_menu_012345678901"
    When  a client requests POST /freeswitch/ivr_menus with:
          | name                      | value         |
          | Caller-Destination-Number | 012345678901  |
    Then the xml node "//menu/@name" should be "ivr_menu_012345678901"
    Then the xml node "//menu/@greet-long" should contain "Welcome to Mr Plumb the plumber"
    Then the xml node "//menu/@greet-long" should contain "press one to be connected to one of our agents"
    Then there should not be an xml node "//entry/@param" containing "transfer 449876543210"
