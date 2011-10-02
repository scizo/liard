class TestClient
  attr_reader :buffer

  def initialize(host, port)
    @socket = Socket.tcp(host, port)
    @buffer = BufferedTokenizer.new "\r\n"
    @messages = []
  end

  def send_command(data)
    @socket.write("#{data}\r\n")
  end

  def messages
    update_messages!
    @messages
  end

  def text
    @text ||= @socket.recv_nonblock(100000)
  end

  def close
    @socket.close
  end

  def update_messages!
    @messages.concat @buffer.extract(text)
    @messages
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

When /^I connect to the server$/ do
  @client = TestClient.new('localhost', 9001)
end

When /^I send "([^"]*)"$/ do |command|
  @client.send_command(command)
end

Then /^I should see "([^"]*)"$/ do |message|
  @client.messages.should include(message)
end

Then /^I should see$/ do |message|
  #puts message
  #puts message.tr("\n", "\r\n")
  @client.text.should include(message.gsub(/\n/, "\r\n"))
end
