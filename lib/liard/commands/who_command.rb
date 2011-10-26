module Liard
  module Commands
		module WhoCommand
			def self.call(connection, args)
				return connection.error('Must set name first') unless connection.player
				connection.server.who(*args).each do |player|
					connection.send "PLAYER #{player.name} #{player.number_of_dice}"
				end
			end
		end
  end
end
