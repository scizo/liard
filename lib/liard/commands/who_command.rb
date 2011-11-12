module Liard
  module Commands
		module WhoCommand
			def self.call(connection, args)
				connection.server.who(*args).each do |player|
					connection.send "PLAYER #{player.name} #{player.number_of_dice}"
				end
			end
		end
  end
end
