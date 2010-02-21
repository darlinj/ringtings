@e2e
Feature: IVR menu entry
  Scenario: Adding an IVR menu entry
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_type   | SyntheticVoiceMenuEntry       |
      | ivr_menu_entry1_action | hello peeps                   |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_type   | TransferCallMenuEntry         |
      | ivr_menu_entry2_action | 1234567890                    |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I click the "Add a menu option" image button
    And I click the form input with id "SyntheticVoiceMenuEntry"
    Then the response should have 3 elements that match "//div[@class='ivr_step_action']"
    And I should see "your announcement here"

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
      | ivr_menu_entry1_type   | SyntheticVoiceMenuEntry       |
      | ivr_menu_entry1_action | hello peeps                   |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_type   | TransferCallMenuEntry         |
      | ivr_menu_entry2_action | 1234567890                    |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I click the delete button for the first ivr menu entry
    Then the response should have 1 elements that match "//div[@class='ivr_step_action']"
    And I should not see "say hello peeps"

  Scenario: Adding a file to a play audio file menu entry
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_type   | PlayAudioFileMenuEntry        |
      | ivr_menu_entry1_action | hello peeps                   |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I click the upload file button for the first ivr menu entry
    And I fill in "File name" with "/etc/passwd"
    And I click the upload button
    And I should see "passwd"

