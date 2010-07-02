Feature: Freeswitch user lookup
  Scenario: Freeswitch needs to be able to query users
    Given we create a Callplan with these variables:
      | name                   | value                         |
      | Action_type            | ivr                           |
      | Action_params          | ivr_menu_0192837465           |
      | inbound_phone_number   | 0192837465                    |
     When  a client requests POST /freeswitch/directory with:
          | name         | value         |
          | user         | 0192837465    |
    Then the xml node "//user/@id" should be "0192837465"


