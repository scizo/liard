require_relative 'dice_set'

module Liard
  class Player
    attr_reader :name
    attr_accessor :ready

    def initialize(name, connection)
      @name = name
      @connection = connection
      @ready = false
    end

    def roll
      @dice = DiceSet.new(5) unless @dice
      @dice.roll
      send "ROLL #{@dice.join(' ')}"
    end

    def number_of_dice
      @dice ? @dice.count : 0
    end

    def send(message)
      @connection.send(message)
    end
  end
end
