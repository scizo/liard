require 'eventmachine'
require 'liard/server'
require 'liard/client'

module Liard
  def self.start_client(host, port, output=STDOUT)
    EM.connect(host, port, Client, output)
  end
end
