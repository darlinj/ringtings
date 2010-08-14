Feature: Voicemail file management
@wip
  Scenario: Listing your voicemail
   Given I have signed in with "joe@foo.com/secret"
    And we create a standard Callplan
    And the callplan is owned by "joe@foo.com"
    And I mock 3 voicemail messages in my voicemail
    When I follow "voicemail"
    Then the response should have 3 elements that match "//div[@class='voicemail']"
