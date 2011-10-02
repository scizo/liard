require 'spec_helper'
require 'liard'

describe Liard do
  include EventedSpec::SpecHelper

  describe '.start_client' do
    it 'connects to the server' do
      EM.should_receive(:connect).with('localhost', 9001, Liard::Client, STDOUT)

      em do
        Liard.start_client('localhost', 9001)
        done
      end
    end

    it 'returns an instance of Client' do
      em do
        result = Liard.start_client('localhost', 9001)
        result.should be_kind_of(Liard::Client)
        done
      end
    end
  end
end
