module Liard
  class Player
    attr_reader :name

    def initialize(name, connection)
      @name = name
      @connection = connection
    end

    def number_of_dice
      0
    end

    def send(message)
      @connection.send(message)
    end
  end
end
