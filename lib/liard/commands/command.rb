module Liard
  module Commands
		class Command
      def self.call(connection, args)
        new(connection, args).run
      end

			def initialize(connection, args)
				@connection = connection
				@args = args
			end

			# To be overwritten by subclasses
			def run
			end
		end
  end
end
