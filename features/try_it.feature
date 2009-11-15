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
    When I click the form input with id "next_submit_image"
    When I wait for the AJAX call to finish
    Then I should see "Ring Mr Plumb the plumber at 0123456789"
    When Freeswitch posts "Caller-Destination-Number=0123456789" parameters to "ringtings.test.local/freeswitch/callplan"
    Then Freeswitch should find "Welcome to Mr Plumb the plumber, all our operators are busy right now. Please call back soon" in the XML
    And I should see "Did you hear a personalised message?"
    Then I should see "Please fill in your email address and a phone number"
    Given I fill in "Email address" with "plumb@plumber.com"
    And I fill in "Phone number" with "0987654321"
    When I click the form input with id "next_submit_image"
    Then I should see "Please ring 0123456789 again"
    When Freeswitch posts "Caller-Destination-Number=0123456789" parameters to "ringtings.test.local/freeswitch/callplan"
    Then Freeswitch should find "application='ivr'" in the XML
    Then Freeswitch should find "data='ivr_menu_0123456789'" in the XML
    When Freeswitch posts "Caller-Destination-Number=0123456789" parameters to "ringtings.test.local/freeswitch/ivr_menus"
    Then Freeswitch should find "ivr_menu_0123456789" in the XML
    Then Freeswitch should find "Welcome to Mr Plumb the plumber" in the XML
    Then Freeswitch should find "press one to be connected to one of our agents" in the XML
    Then Freeswitch should find "press two to be connected to leave a message" in the XML
    Then Freeswitch should find "transfer 0987654321" in the XMLA
    Then I should be on the "Callplan" page
    And I should see "This is your calling plan so far"
    When I click the save button
    Then I should see "To save this call plan please enter a password"
    When I fill in "Password" with "Password"
    And I fill in "Confirm Password" with "Password"
    And I click on "save"
    Then I should see "Your new callplan has been saved successfully"
    

