module Liard
  class Random
    class << self
      def seed(seed)
        @generator = ::Random.new(seed)
      end

      def generator
        @generator ||= ::Random.new
      end

      def random_die
        generator.rand(1..6)
      end
    end
  end
end
