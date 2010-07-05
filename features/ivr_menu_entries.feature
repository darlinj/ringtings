Feature: IVR menu entry
  Scenario: Adding an IVR menu entry
    Given we create a Callplan with these variables:
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
    When I go to the current callplan page
    And I follow "add_menu_option_submit_image"
    And I click the form input with id "SyntheticVoiceMenuEntry"
    Then the response should have 3 elements that match "//div[@class='ivr_step_action']"
    And I should see "your announcement here"

  Scenario: Deleting a IVR menu entry
    Given we create a Callplan with these variables:
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
    When I go to the current callplan page
    And I click the delete button for the first ivr menu entry
    Then the response should have 1 elements that match "//div[@class='ivr_step_action']"
    And I should not see "say hello peeps"

  Scenario: Uploading a new file for a play audio file menu entry
    Given we create a Callplan with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_01928374650          |
      | inbound_phone_number   | 01928374650                   |
    And we have an IVR Menu with:
      | name                   | value                         |
      | long_greeting          | some long greeting            |
      | ivr_menu_entry1_digit  | 1                             |
      | ivr_menu_entry1_type   | PlayAudioFileMenuEntry        |
      | ivr_menu_entry1_action | hello peeps                   |
    And I am logged in
    When I go to the current callplan page
    And I click the change button for the first ivr menu entry
    Then I should see "Please choose a file"
    And I type "freeswitch_stuff/suckingteeth.wav" in the form field with an HTML id of "play_audio_file_menu_entry_audio"
    When I click the upload file button
    And I should see "Callplan sucessfully saved"
    And I should see "suckingteeth.wav"
