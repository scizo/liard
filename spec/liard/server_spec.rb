require 'spec_helper'
require 'liard/server'

module Liard

describe Server do
  include EventedSpec::SpecHelper

  before(:each) do
    EM.stub(:start_server)
    @server = Server.new
  end

  describe '#new' do
    it 'should start listening on given port' do
      EM.should_receive(:start_server).with('0.0.0.0', 9001, ServerConnection, instance_of(Server))

      em do
        Server.new
        done
      end
    end
  end

  context 'with two players connected' do
    before(:each) do
      @scott = double('player', name: 'scott')
      @fred = double('player', name: 'fred')
      @server.stub(:players).and_return([@scott, @fred])
    end

    describe '#who' do
      it 'returns all players when no arguments are given' do
        @server.who.should == [@scott, @fred]
      end

      it 'returns the players with the given names when arguments are passed in' do
        @server.who('fred').should == [@fred]
      end
    end

    describe '#player_exists?' do
      context 'given a connected player' do
        it 'should return true' do
          @server.player_exists?('scott').should be(true)
        end
      end

      context 'given a name without a corresponding connection' do
        it 'should return false' do
          @server.player_exists?('notconnected').should be(false)
        end
      end
    end
  end

  describe '#add_player?' do
    it 'adds a player to the server' do
      player = double('player')
      @server.add_player(player)

      @server.players.should == [player]
    end
  end
end

end
