require 'simplecov' if ENV['COVERAGE']
$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'liard'

class TestClient
  attr_reader :buffer

  def initialize(host, port)
    @socket = Socket.tcp(host, port)
    @buffer = BufferedTokenizer.new "\r\n"
    @messages = []
  end

  def connected?
    !select([@socket], nil, nil, 0.1)
  end

  def send_command(data)
    @socket.write("#{data}\r\n")
  end

  def messages
    return @messages.concat(@buffer.extract(text)) if @messages.empty?
    @messages
  end

  def text
    @text ||= @socket.recv_nonblock(100000)
  end

  def close
    @socket.close
  end
end
