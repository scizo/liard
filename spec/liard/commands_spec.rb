require 'spec_helper'
require 'liard/commands'

module Liard

describe Commands do
  describe '.get_command' do
    context 'given a known command' do
      it 'returns the given command' do
        Commands.get_command('HELP').should == Commands::HelpCommand
      end
    end

    context 'given an unknown command' do
      it 'returns an instance of UnknownCommand' do
        Commands.get_command('DERP').should be_kind_of(Commands::UnknownCommand)
      end
    end
  end
end

end
