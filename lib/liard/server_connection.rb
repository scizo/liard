require 'eventmachine'
require 'liard/commands'

module Liard
  module ServerConnection
    include EM::Protocols::LineText2

    attr_accessor :server, :player

    def initialize(server)
      @server = server
    end

    def post_init
      set_delimiter "\r\n"
      send_data "Welcome to Liard!!!\r\n"
      set_timer(15) do
        error('Must set name within 15 seconds')
        close_connection(true)
      end
    end

    def receive_line(line)
      command, *args = line.split
		  return error('Must set name first') unless player || ['SETNAME', 'HELP'].include?(command.upcase)
      callable = Commands.get_command(command.upcase)
      callable.call(self, args)
    end

    def send(data)
      send_data "#{data.gsub(/(?<!\r)\n/, "\r\n")}\r\n"
    end

    def error(message)
      send_data "ERROR #{message}\r\n"
    end

    def set_timer(seconds, &block)
      raise ArgumentError.new "block required" unless block
      raise RuntimeError.new "timer already exists" if @timer
      @timer = EM::Timer.new(seconds, &block)
    end

    def cancel_timer
      @timer && @timer.cancel
      @timer = nil
    end
  end
end
