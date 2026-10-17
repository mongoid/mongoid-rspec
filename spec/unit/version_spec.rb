# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Standalone version entry point' do
  it 'defines the gem version when loaded independently' do
    expected_version = Mongoid::RSpec::VERSION
    hide_const('Mongoid::RSpec::VERSION')

    begin
      load File.expand_path('../../lib/mongoid/rspec/version.rb', __dir__)

      expect(Mongoid::RSpec::VERSION).to eq(expected_version)
      expect(Gem::Version.new(Mongoid::RSpec::VERSION)).to be_a(Gem::Version)
    ensure
      Mongoid::RSpec.send(:remove_const, :VERSION) if Mongoid::RSpec.const_defined?(:VERSION, false)
    end
  end
end
