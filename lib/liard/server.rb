require 'liard/server_connection'

module Liard
  class Server
    def initialize(port=9001)
      EM.start_server '0.0.0.0', port, ServerConnection
    end
  end
end
