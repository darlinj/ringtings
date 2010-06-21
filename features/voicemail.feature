@e2e
Feature: Voicemail file management
  Scenario: Freeswitch needs to be able to query users 
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    When Freeswitch posts "Caller-Destination-Number=0192837465" parameters to "ringtings.test.local/freeswitch/directory"
    Then Freeswitch should find "application='ivr'" in the XML
 
  #Scenario: Listing your voicemail
    #Given I have 3 voicemail files in my directory
    #And I am logged in
    #When I click on "voicemail"
    #Then I should see three file objects
