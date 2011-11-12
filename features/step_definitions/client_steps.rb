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
    @socket.close if connected?
  end
end

Before do
  Thread.new { EM.run }.run
end

After do
  EM.stop
  @client && @client.close
end

Given /^The server is running$/ do
  EM.next_tick { Liard::Server.new }
end

Given /^I am connected to the server$/ do
  Given "The server is running"
  When "I connect to the server"
end

Given /^I have set my name as "([^"]*)"$/ do |name|
  Given "I am connected to the server"
  When "I send \"SETNAME #{name}\""
end

When /^I connect to the server$/ do
  @client = TestClient.new('localhost', 9001)
end

When /^I send "([^"]*)"$/ do |command|
  @client.send_command(command)
end

When /^I wait (\d+) seconds$/ do |count|
  sleep count.to_i
end

Then /^I should see "([^"]*)"$/ do |message|
  @client.messages.should include(message)
end

Then /^I should see$/ do |message|
  @client.text.should include(message.gsub(/\n/, "\r\n"))
end

Then /^I should get disconnected$/ do
  @client.should_not be_connected
end
