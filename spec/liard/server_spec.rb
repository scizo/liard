require 'spec_helper'
require 'liard/server'

module Liard

describe Server do
  include EventedSpec::SpecHelper

  describe '#new' do
    it 'should start listening on given port' do
      EM.should_receive(:start_server).with('0.0.0.0', 9001, ServerConnection)

      em do
        Server.new
        done
      end
    end
  end
end

end
