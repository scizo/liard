module Liard
  class DiceSet
    DICE = [1, 2, 3, 4, 5, 6]
    attr_reader :count
    def initialize(count)
      @count = count
    end

    def roll
      @dice = (1..count).map{ DICE.sample }
    end

    def join(string)
      @dice.join(string)
    end
  end
end
