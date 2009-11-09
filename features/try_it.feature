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
    When Freeswitch posts to "ringtings.test.local/freeswitch/callplan" with "Caller-Destination-Number=0123456789" parameters
    Then Freeswitch should find "Welcome to Mr Plumb the plumber, all our operators are busy right now. Please call back soon" in the XML
    And I should see "Did you hear a personalised message?"
    Then I should see "Please fill in your email address and a phone number"
    Given I fill in "Email address" with "plumb@plumber.com"
    And I fill in "Phone number" with "0987654321"
    When I click the form input with id "next_submit_image"
    Then I should see "Please ring 0123456789 again"
    When Freeswitch posts to "ringtings.test.local/freeswitch/callplan" with "Caller-Destination-Number=0123456789" parameters
    Then Freeswitch should find "Somthing like application=IVRthing" in the XML

  Scenario: Extending the callplan
   And I type "0987654321" in the form field with an HTML id of "phone_number"
    And I click on "next"
    And I should see "Please ring this number now"
    When Freeswitch goes to the freeswitch interface
    And Freeswitch should see "Welcome to Mr Plumb the plumber, please press 1 to talk to Bob or 2 to leave a message"
    And If I press 2 And leave the message "hello, please come and do some plumbing"
    Then I should receive an email with subject "There is a new message for you"
    And If I ring that number I should hear "Welcome to Mr Plumb the plumber, please press 1 to talk to Bob or 2 to leave a message"
    And If I press 1 I should hear ringing on the phone "0987654321"
    And I should see "This is your calling plan so far"
    And I should see "To save this plan enter a password"
    And I should see "Your username is plumb@plumber.com"
    And I type "password" in the form field with an HTML id of "user_password"
    And I type "password" in the form field with an HTML id of "user_password_confirmation"
    Then I should see "Welcome plumb@plumber.com"
    And I should see "log out"
    And I should be on the call plan editing screen.
    
  

