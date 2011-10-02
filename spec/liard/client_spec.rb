require 'spec_helper'
require 'liard/client'

module Liard

class ClientClass
  include Client
end

class Output
  attr_accessor :messages

  def initialize
    @messages = []
  end

  def puts(message)
    @messages << message
  end
end

describe Client do
  before(:each) do
    @output = Output.new
    @client = ClientClass.new(@output)
  end

  describe '#help' do
    it 'should send the help command to the server' do
      @client.should_receive(:send_data).with("HELP\r\n")
      @client.help
    end
  end
end

end
