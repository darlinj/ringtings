Feature: Voicemail file management
  Scenario: Listing your voicemail
    Given I am logged in
    And we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And I mock the response from freeswitch voicemail interface
    When I follow "voicemail"
    Then the response should have 3 elements that match "//div[@class='voicemail']"
