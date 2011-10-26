Feature: client sets name

  As a client
  I want to be able to set my name
  So that I can issue other commands

  Scenario: issue command without name being set
    Given I am connected to the server
    When I send "WHO"
    Then I should see "ERROR Must set name first"

  Scenario: list players after setting name
    Given I have set my name as "scott"
    When I send "WHO"
    Then I should see "PLAYER scott 0"

  Scenario: do not set name
    Given I am connected to the server
    When I wait 17 seconds
    Then I should see "ERROR Must set name within 15 seconds"
    And I should get disconnected
