Feature: Voicemail file management
  Scenario: Listing your voicemail
    Given I have 3 voicemail files in my directory
    And I am logged in
    When I click on "voicemail"
    Then I should see three file objects
