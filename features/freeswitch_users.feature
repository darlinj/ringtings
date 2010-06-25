@e2e
Feature: Voicemail user lookup
  Scenario: Freeswitch needs to be able to query users
    Given we create a Callplan (and store it's ID as <callplan_id>) with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
    When Freeswitch posts "user=0192837465" parameters to "ringtings.test.local/freeswitch/directory"
    Then Freeswitch should find "0192837465" in the XML


