module Liard
  module Commands
    module ReadyCommand
      def self.call(connection, args)
        connection.player.ready = true
        connection.send "MESSAGE You are currently ready, UNREADY to switch"
        message = "MESSAGE #{connection.player.name} is READY!"
        connection.server.send_to_others(connection.player, message)
        connection.server.check_for_start
      end
    end
  end
end
