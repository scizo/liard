require 'liard/commands/help_command'
require 'liard/commands/set_name_command'
require 'liard/commands/who_command'

module Liard
	module Commands
		COMMANDS = {
			'HELP' => HelpCommand,
			'SETNAME' => SetNameCommand,
			'WHO' => WhoCommand
		}

		def self.get_command(command_name)
			COMMANDS.fetch(command_name)
		end
	end
end
