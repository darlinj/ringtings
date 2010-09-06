Feature: Voicemail file management
  Scenario: Listing your voicemail
   Given I have signed in with "joe@foo.com/secret"
     And we create a standard Callplan
     And the callplan is owned by "joe@foo.com"
     And I mock 3 voicemail messages in my voicemail
   When I follow "voicemail"
   Then the response should have 3 elements that match "//div[@class='voicemail']/table/tbody/tr"

  Scenario: showing an empty list
    Given I have signed in with "joe@foo.com/secret"
    And we create a standard Callplan
    And the callplan is owned by "joe@foo.com"
    And I mock a empty voicemail response
    When I follow "voicemail"
    Then I should see "You currently have no voicemail"

@wip
  Scenario: Downloading a voicemail message
    Given I have signed in with "joe@foo.com/secret"
      And we create a standard Callplan
      And the callplan is owned by "joe@foo.com"
      And I mock 3 voicemail messages in my voicemail
      And I mock a voicemail file response
    When I follow "voicemail"
      And I click on the first Download link
    Then I should receive a file in the response




