Feature: Voicemail file management
@wip
  Scenario: Listing your voicemail
   Given I have signed in with "joe@foo.com/secret"
    And we create a standard Callplan
    And the callplan is owned by "joe@foo.com"
    And I mock 3 voicemail messages in my voicemail
    When I follow "voicemail"
    Then the response should have 3 elements that match "//div[@class='voicemail']"

@wip
  Scenario: showing an empty list
    Given I have signed in with "joe@foo.com/secret"
    And we create a Callplan with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And the callplan is owned by "joe@foo.com"
    And I have an empty voicemail directory
    When I follow "voicemail"
    Then I should see "You currently have no voicemail"



