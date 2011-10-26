module Liard
  module Commands
		module HelpCommand
      def self.call(connection, args)
        connection.send HELP_MESSAGE
      end

			HELP_MESSAGE = """\
  -- Commands from client

  HELP [<command>]                  Lists these commands, or command specific help if a command is given
 *SETNAME <name>                    Set a unique name to identify the connection
  UNREADY                           Set client status to \"not ready\" for restart
  READY                             Set client status to \"ready\" for restart
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

*Must be called before other commands and within 15 seconds of connecting."""
		end
  end
end
