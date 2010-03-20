Feature: Expire callplans
  In order to recycle inbound numbers
  the system
  Should delete callplans that haven't been updated in over 1 hour

  Scenario: Expiring the callplan
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
    And we store the inbound number
    And we set the modified date for callplan to 2 hours ago
    When we run the expire callplans function
    Then the callplan should be gone
    And the inbound number is freed up
