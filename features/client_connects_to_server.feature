Feature: client connects to server

  As a client
  I want to connect to the server
  So that I can play the game

  Scenario: connect to server
    Given The server is running
    When I connect to the server
    Then I should see "Welcome to Liard!!!"
