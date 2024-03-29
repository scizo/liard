Before do
  Liard::Random.seed(5)
  thread = Thread.new { EM.run }
  thread.abort_on_exception = true
  thread.run
end

After do
  EM.stop if EM.reactor_running?
  @client && @client.close
  @other_players && @other_players.each{|p| p.close}
end

Given /^The server is running$/ do
  EM.next_tick { Liard::Server.new }
end

Given /^I am connected to the server$/ do
  Given "The server is running"
  When "I connect to the server"
end

Given /^I have sent "([^"]*)"$/ do |command|
  When "I send \"#{command}\""
end

Given /^I have set my name as "([^"]*)"$/ do |name|
  Given "I am connected to the server"
  When "I send \"SETNAME #{name}\""
end

Given /^(\d+) other players are connected$/ do |count|
  @other_players = []
  (1..count.to_i).each do |number|
    player = TestClient.new('localhost', 9001)
    player.send_command("SETNAME player_#{number}")
    @other_players << player
  end
end

Given /^(\d+) other players are ready$/ do |count|
  Given "#{count} other players are connected"
  @other_players.each{|p| p.send_command("READY")}
end

Given /^player_(\d+) is ready$/ do |player_number|
  @other_players[player_number.to_i - 1].send_command("READY")
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

Then /^I should not see "([^"]*)"$/ do |message|
  @client.messages.should_not include(message)
end

Then /^the other players should see "([^"]*)"$/ do |message|
  @other_players.each do |player|
    player.messages.should include(message)
  end
end

Then /^I should get a roll with (\d+) dice$/ do |count|
  roll = /^ROLL ([1-6] ){#{count.to_i - 1}}[1-6]$/
  #puts @client.messages.find{|m| m =~ roll}
  @client.messages.any?{|m| m =~ roll}.should be(true)
end

Then /^player_(\d+) has ([1-9]) dice$/ do |player_number, count|
  player = @other_players[player_number.to_i - 1]
  roll = /^ROLL ([1-6] ){#{count.to_i - 1}}[1-6]$/
  #puts player.messages.find{|m| m =~ roll}
  player.messages.any?{|m| m =~ roll}.should be(true)
end

Then /^player_(\d+) has 0 dice$/ do |player_number|
  player = @other_players[player_number.to_i - 1]
  player.messages.all?{|m| m !~ /^ROLL/}.should be(true)
end

Then /^I should get disconnected$/ do
  @client.should_not be_connected
  EM.stop
  sleep 0.25
end
