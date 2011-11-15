module Liard
  module Commands
    module UnreadyCommand
      def self.call(connection, args)
        connection.player.ready = false
        connection.send "MESSAGE You are no longer ready, READY to switch"
        message = "MESSAGE #{connection.player.name} is no longer READY"
        connection.server.send_to_others(connection.player, message)
        connection.server.check_for_start
      end
    end
  end
end
