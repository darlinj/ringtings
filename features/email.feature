Feature: Email
  Scenario: email is sent when callplan is created
    Given we create a demo callplan
    Then an email message should be sent to "joe.darling@bt.com"
