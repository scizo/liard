require_relative 'server_connection'
require_relative 'game'

module Liard
  class Server
    attr_reader :players, :game

    def initialize(port=9001)
      @players = []
      EM.start_server '0.0.0.0', port, ServerConnection, self
    end

    def send_to_all(message)
      players.each do |player|
        player.send(message)
      end
    end

    def send_to_others(player, message)
      players.select{|p| p != player}.each do |player|
        player.send(message)
      end
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

    def check_for_start
      if players.count(&:ready) == players.count
        start_game
      elsif !@timer && players.count(&:ready) >= 3
        send_to_all "STARTING"
        @timer = EM::Timer.new(15, &method(:start_game))
      elsif @timer && players.count(&:ready) < 3
        send_to_all "MESSAGE Less than 3 players ready. Start aborted."
        @timer.cancel
      end
    end

    def start_game
      if @timer
        @timer.cancel
        @timer = nil
      else
        send_to_all "STARTING"
      end
      @game = Game.new(self, players.select(&:ready))
    end
  end
end
