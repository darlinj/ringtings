@e2e
Story: Try it out page
  Scenario: trying the service
    Given I am logged out
    And we clear the "InboundNumberManager" model
    And and "0123456789" is stored in the "inbound_number_manager" table in the database
    When I go to the homepage
    And I follow "try it free"
    Then I should see "Enter the name of your business"
    When I fill in "Company name" with "Mr Plumb the plumber"
    Then I should see "Please fill in the phone number of a handy phone"
    And I fill in "Phone number" with "0987654321"
    When I click the form input with id "next_submit_image"
    And I should see "Here is your first callplan"
    Then I should see "Please ring 0123456789"
    Then I should see "Please create an account."
    Given I fill in "Email" with "plumb@plumber.com"
    When I fill in "Password" with "Password"
    And I fill in "Confirm password" with "Password"
    When I click the form input with id "next_submit_image"
    Then I should see "You will receive an email within the next few minutes. It contains instructions for confirming your account."
    And I should see "Well you can start editing your callplan to you own needs"
    When Freeswitch posts "Caller-Destination-Number=0123456789" parameters to "ringtings.test.local/freeswitch/callplan"
    Then Freeswitch should find "application='ivr'" in the XML
    Then Freeswitch should find "data='ivr_menu_0123456789'" in the XML
    When Freeswitch posts "Caller-Destination-Number=0123456789" parameters to "ringtings.test.local/freeswitch/ivr_menus"
    Then Freeswitch should find "ivr_menu_0123456789" in the XML
    Then Freeswitch should find "Welcome to Mr Plumb the plumber" in the XML
    Then Freeswitch should find "press one to be connected to one of our agents" in the XML
    Then Freeswitch should find "press two to be connected to leave a message" in the XML
    Then Freeswitch should find "transfer 0987654321" in the XML
