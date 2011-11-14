require_relative 'server_connection'

module Liard
  class Server
    attr_reader :players

    def initialize(port=9001)
      @players = []
      EM.start_server '0.0.0.0', port, ServerConnection, self
    end

    def who(*names)
      return players if names.empty?
      players.select{|player| names.include?(player.name)}
    end

    def player_exists?(name)
      players.any?{|player| player.name == name}
    end

    def add_player(player)
      players << player
    end
  end
end
