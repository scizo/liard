require_relative 'random'

module Liard
  class DiceSet
    attr_reader :count
    def initialize(count)
      @count = count
    end

    def roll
      @dice = (1..count).map{ Random.random_die }
    end

    def join(string)
      @dice.join(string)
    end
  end
end
