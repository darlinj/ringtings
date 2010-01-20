@e2e
Story: Callplan management

  Scenario: Displaying an existing ivr menu callplan
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_prompt | Synthetic voice says:         |
      | ivr_menu_entry1_action | say hello peeps               |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_prompt | Transfer call to:             |
      | ivr_menu_entry2_action | transfer 1234567890           |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I should see "Incoming calls to: 0192837465"
    And I should see "some long greeting"
    And I should see "1"
    And I should see "Synthetic voice says:"
    And I should see "hello peeps"
    And I should see "2"
    And I should see "Transfer call to:"
    And I should see "1234567890"


  Scenario: Saving a feature
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_prompt | Synthetic voice says:         |
      | ivr_menu_entry1_action | say hello peeps               |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_prompt | Transfer call to:             |
      | ivr_menu_entry2_action | transfer 1234567890           |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I type "some new greeting" in the form field with an HTML id of "callplan_action_attributes_ivr_menu_attributes_long_greeting"
    And I click the form input with id "save_button"
    Then I should see "Callplan sucessfully saved"
    And I should see "some new greeting"
    And I should not see "some long greeting"

  Scenario: Deleting a IVR menu entry
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_prompt | Synthetic voice says:         |
      | ivr_menu_entry1_action | say hello peeps               |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_prompt | Transfer call to:             |
      | ivr_menu_entry2_action | transfer 1234567890           |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I click the delete button for the first ivr menu entry
    Then the response should have 1 elements that match "//div[@class='ivr_step_action']"
    And I should not see "say hello peeps"

