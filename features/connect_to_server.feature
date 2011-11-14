Feature: client connects to server

  First things first: A client must be able to connect to the server

  Scenario: connect to server
    Given The server is running
    When I connect to the server
    Then I should see "Welcome to Liard!!!"
