Feature: cannot issues commands without setting name

  Before a client is able to issue commands they must first set their name
  The only exception is the help command

  Background:
    Given I am connected to the server

  Scenario: issue help command
    When I send "HELP"
    Then I should see
      """
        -- Commands from client

        HELP [<command>]                  Lists these commands, or command specific help if a command is given
       *SETNAME <name>                    Set a unique name to identify the connection
        UNREADY                           Set client status to "not ready" for restart
        READY                             Set client status to "ready" for restart
        BID <num> <val>                   Creates a bid of <num> <val> (e.g. four 3's)
        CHALLENGE                         Challenges last bid (if one exists)
        CHAT <msg>                        Sends a message to all clients
        WHO [<name> ...]                  Request a list of PLAYER responses from the server
        WHOSETURN                         Request a CURRENTTURN response from server

        -- Commands from server

        BID <name> <num> <val>            Indicates a bid from <name> of <num> <val> (e.g. eight 5's)
        CHALLENGE <name>                  Indicates a challenge from <name>
        CHAT <name>: <msg>                Indicates a chat message from <name>
        CURRENTTURN <name> <seconds>      Indicates whose turn it is and how much time before they timeout
        LOSEDICE <name> <dice>            Indicates that <name> lost <dice> number of dice
        LOSEDICEALL <name>                Indicates that all remaining players, except <name>, lose one die each
        PLAYER <name> <dice>              Indicates how many remaining dice a player has
        RESULT <name> <#> [<#> ...]       Reveals another person's roll (after a challenge)
        ROLL <#> [<#> ...]                Your roll for the round
        STARTING                          Indicates a restart in 15 seconds or when all clients report ready (whichever occurs first)
        MESSAGE <message>                 Precedes any general communication from the server
        ERROR <message>                   Precedes any error communications from the server

      *Must be called before other commands and within 15 seconds of connecting.

      """

  Scenario: issue command without name being set
    When I send "WHO"
    Then I should see "ERROR Must set name first"

  Scenario: list players after setting name
    When I send "SETNAME scott"
    And I send "WHO"
    Then I should see "PLAYER scott 0"

  Scenario: do not set name
    When I wait 17 seconds
    Then I should see "ERROR Must set name within 15 seconds"
    And I should get disconnected
