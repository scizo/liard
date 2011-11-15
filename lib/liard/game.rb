module Liard
  class Game
    def initialize(server, players)
      @server = server
      @players = players
      start_round
    end

    def start_round
      @players.each do |player|
        player.roll
      end
    end
  end
end
