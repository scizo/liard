Feature: client issues an unknown command

  As a client
  If I issue an unknown command
  I don't want to kill the server

  Scenario: issue unknown command
    Given I have set my name as "scott"
    When I send "DERP"
    Then I should see "ERROR unknown command DERP"
