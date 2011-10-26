require 'liard/commands/command'
require 'liard/player'

module Liard
  module Commands
		class SetNameCommand < Command
			def run
				return @connection.error("Wrong number of arguments for SETNAME (#{@args.length} for 1)") if @args.length != 1
				@connection.cancel_timer
				create_player(@connection.server, @args[0])
			end

			def create_player(server, name)
				return @connection.error("Name already set") if @connection.player
				return @connection.error("Name already exists") if server.player_exists?(name)
				@connection.player = Player.new(name, @connection)
				server.add_player(@connection.player)
			end
		end
  end
end
