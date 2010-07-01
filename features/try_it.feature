@e2e
Feature: Try it out page
  Scenario: trying the service
    Given I am logged out
    And we clear the "InboundNumberManager" model
    And and "012345678901" is stored in the "inbound_number_manager" table in the database
    When I go to the homepage
    And I fill in "Company name" with "Mr Plumb the plumber"
    And I fill in "Phone number" with "09876543210"
    When I click the form input with id "next_submit_image"
    And I should see "Here is your first callplan"
    Then I should see "Ring 012345678901"
    Then I should see "please create a free account."
    Given I fill in "Email" with "plumb@plumber.com"
    When I fill in "Password" with "Password"
    And I fill in "Confirm password" with "Password"
    When I click the form input with id "next_submit_image"
    Then I should see "You will receive an email within the next few minutes. It contains instructions for confirming your account."
    And I should see "Well you can start editing your callplan to you own needs"
    When Freeswitch posts "Caller-Destination-Number=012345678901" parameters to "ringtings.test.local/freeswitch/callplan"
    Then Freeswitch should find "application='ivr'" in the XML
    Then Freeswitch should find "data='ivr_menu_012345678901'" in the XML
    When Freeswitch posts "Caller-Destination-Number=012345678901" parameters to "ringtings.test.local/freeswitch/ivr_menus"
    Then Freeswitch should find "ivr_menu_012345678901" in the XML
    Then Freeswitch should find "Welcome to Mr Plumb the plumber" in the XML
    Then Freeswitch should find "press one to be connected to one of our agents" in the XML
    Then Freeswitch should find "press two to be connected to leave a message" in the XML
    Then Freeswitch should find "transfer 44987654321" in the XML
