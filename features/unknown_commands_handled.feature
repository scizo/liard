Feature: unknown commands don't crash server

  The server should be robust and handle unknown commands without crashing

  Background:
    Given I have set my name as "scott"

  Scenario: issue unknown command
    When I send "DERP"
    Then I should see "ERROR unknown command DERP"
