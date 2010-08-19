Feature: Voicemail file management
  Scenario: Listing your voicemail
   Given I have signed in with "joe@foo.com/secret"
    And we create a standard Callplan
    And the callplan is owned by "joe@foo.com"
    And I mock 3 voicemail messages in my voicemail
    When I follow "voicemail"
    Then the response should have 3 elements that match "//div[@class='voicemail']"

  Scenario: showing an empty list
    Given I have signed in with "joe@foo.com/secret"
    And we create a standard Callplan
    And the callplan is owned by "joe@foo.com"
    And I mock a empty voicemail response
    When I follow "voicemail"
    Then I should see "You currently have no voicemail"



