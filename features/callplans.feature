Feature: Callplan management

  Scenario: Displaying an existing ivr menu callplan
    Given I have a standard callplan
    And I am logged in
    When I go to the current callplan page
    And I should see "Incoming calls to: 0192837465"
    And I should see "some long greeting"
    And I should see "1"
    And I should see "Synthetic voice says:"
    And I should see "hello peeps"
    And I should see "2"
    And I should see "Transfer call to:"
    And I should see "1234567890"


  Scenario: Saving a feature
    Given I have a standard callplan
    And I am logged in
    When I go to the current callplan page
    And I type "some new greeting" in the form field with an HTML id of "callplan_action_attributes_ivr_menu_attributes_long_greeting"
    And I click the form input with id "save_button"
    Then I should see "Callplan sucessfully saved"
    And I should see "some new greeting"
    And I should not see "some long greeting"

  Scenario: Saving a callplan with two digits set the same
    Given I have a standard callplan
    And I am logged in
    When I go to the current callplan page
    And I set the digits to the same number
    And I click the form input with id "save_button"
    Then I should see "Callplan not saved"
    And I should see "actions should have a unique digit"

  Scenario: Deleting a IVR menu entry
    Given I have a standard callplan
    And I am logged in
    When I go to the current callplan page
    And I click the delete button for the first ivr menu entry
    Then the response should have 1 elements that match "//div[@class='ivr_step_action']"
    And I should not see "say hello peeps"

