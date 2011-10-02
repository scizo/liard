require 'eventmachine'

module Liard
  module Client
    include EM::Protocols::LineText2
    attr_accessor :output

    def initialize(output=STDOUT)
      @output = output
    end

    def post_init
      set_delimiter "\r\n"
    end

    def receive_line(line)
      @output.puts line
    end

    def help
      send_data "HELP\r\n"
    end
  end
end
