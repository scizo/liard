require_relative 'commands/help_command'
require_relative 'commands/set_name_command'
require_relative 'commands/who_command'
require_relative 'commands/ready_command'
require_relative 'commands/unready_command'

module Liard
  module Commands
    COMMANDS = {
      'HELP' => HelpCommand,
      'SETNAME' => SetNameCommand,
      'WHO' => WhoCommand,
      'READY' => ReadyCommand,
      'UNREADY' => UnreadyCommand
    }

    class UnknownCommand
      def initialize(command)
        @command = command
      end

      def call(connection, args)
        connection.send "ERROR unknown command #{@command}"
      end
    end

    def self.get_command(command_name)
      COMMANDS.fetch(command_name, UnknownCommand.new(command_name))
    end
  end
end
