Feature: client issues who command

  As a client
  I want to issue the who command
  So that I can see who else is on the server

  Background:
    Given I have set my name as "scott"
    And 2 other players are connected

  Scenario: issue the who command without any arguments
    When I send "WHO"
    Then I should see "PLAYER player_1 0"
    And I should see "PLAYER player_2 0"

  Scenario: issue the who command with a players name
    When I send "WHO player_1"
    Then I should see "PLAYER player_1 0"
    And I should not see "PLAYER player_2 0"
