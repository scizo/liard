Feature: A game will start when enough players are ready

  Clients can toggle their readiness with the ready/unready commands.
  When a minimum of three players are ready a game will be scheduled to start.
  All remaining unready players have 15 seconds to become ready or the game will begin without them.

  Background:
    Given I have set my name as "scott"

  Scenario: issue the ready command
    When I send "READY"
    Then I should see "MESSAGE You are currently ready, UNREADY to switch"

  Scenario: issue the unready command
    Given I have sent "READY"
    When I send "UNREADY"
    Then I should see "MESSAGE You are no longer ready, READY to switch"

  Scenario: issuing the ready command with other clients connected
    Given 2 other players are connected
    When I send "READY"
    Then the other players should see "MESSAGE scott is READY!"

  Scenario: issuing the unready command with other clients connected
    Given 2 other players are connected
    And I have sent "READY"
    When I send "UNREADY"
    Then the other players should see "MESSAGE scott is no longer READY"

  Scenario: issuing the ready command with 2 other clients ready
    Given 2 other players are ready
    When I send "READY"
    Then I should see "STARTING"
    And I should get a roll with 5 dice

  Scenario: beginning the game
    Given 3 other players are connected
    And player_1 is ready
    And player_2 is ready
    When I send "READY"
    And I wait 16 seconds
    Then I should get a roll with 5 dice
    And player_1 has 5 dice
    And player_2 has 5 dice
    And player_3 has 0 dice
