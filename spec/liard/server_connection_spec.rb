require 'spec_helper'
require 'liard/server_connection'

module Liard

class ServerConnectionSpecClass
  include ServerConnection

  def send_data(data); end # send_data stub
end

describe ServerConnection do
  include EventedSpec::EMSpec

  em_before do
    EM.stub(:start_server)
    @connection = ServerConnectionSpecClass.new(double('server'))
  end

  describe '#post_init' do
    it 'should send the welcome message' do
      @connection.should_receive(:send_data).with("Welcome to Liard!!!\r\n")

      @connection.post_init
      done
    end

    it 'should set a timer to expire in 15 seconds' do
      @connection.should_receive(:set_timer).with(15)

      @connection.post_init
      done
    end
  end

  describe '#receive_line' do
    em_before do
      @callable = stub('callable').as_null_object
    end

    it 'gets the command that based on the first word in the line' do
      Commands.should_receive(:get_command).with('HELP').and_return(@callable)

      @connection.receive_line('help please')
      done
    end

    it 'calls the command with the connection and the given args' do
      Commands.stub(:get_command).and_return(@callable)
      @callable.should_receive(:call).with(@connection, ['fred', 'bob'])

      @connection.receive_line('who fred bob')
      done
    end
  end

  describe '#send' do
    it 'adds a carriage return and newline to the data before sending' do
      @connection.should_receive(:send_data).with(/some data\r\n$/)

      @connection.send("some data")
      done
    end

    it 'replaces any single new lines with carriage return new lines before sending' do
      @connection.should_receive(:send_data).with(/^some\r\ndata\r\nis awesome/)

      @connection.send("some\ndata\r\nis awesome")
      done
    end
  end

  describe '#error' do
    it 'adds a carriage return and newline to the message' do
      @connection.should_receive(:send_data).with(/some error\r\n$/)

      @connection.error("some error")
      done
    end

    it 'appends ERROR before the message' do
      @connection.should_receive(:send_data).with(/^ERROR another error/)

      @connection.error("another error")
      done
    end
  end

  describe '#set_timer' do
    it 'creates a timer for the given time' do
      EM::Timer.should_receive(:new).with(15)

      @connection.set_timer(15) {}
      done
    end

    it 'runs the passed in block after the desired time' do
      # this will time out if done is not called
      @connection.set_timer(0.01) { done }
    end

    it 'raises an error if there is no block given' do
      lambda {
        @connection.set_timer(15)
      }.should raise_error(ArgumentError, /block required/)
      done
    end

    it 'raises an error if there is already a pending timer' do
      @connection.set_timer(4) {}
      lambda {
        @connection.set_timer(3) {}
      }.should raise_error(RuntimeError, /timer already exists/)
      done
    end
  end

  describe '#cancel_timer' do
    it 'cancels any set timers' do
      @connection.set_timer(0.01) { fail "Timer not cancelled" }
      @connection.cancel_timer
      EM.add_timer(0.1) { done }
    end
  end
end

end
