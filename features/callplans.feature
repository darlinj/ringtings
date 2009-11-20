@e2e
Story: Callplan management

  Scenario: Displaying an existing ivr menu callplan
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    And we have an IVR Menu with:
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_action | say something                 |
      | ivr_menu_entry2_digit  | 2                             |
      | ivr_menu_entry2_action | transfer 1234567890           |
    And I am logged in
    When I navigate to the "callplan_path" for <callplan_id>
    And I should see "Incoming calls to 0192837465"
    And I should see "some long greeting"
    And I should see "when call presses 1"
    And I should see "computer generated voice"
    And I should see "something"
    And I should see "when call presses 2"
    And I should see "transfer call to"
    And I should see "1234567890"


