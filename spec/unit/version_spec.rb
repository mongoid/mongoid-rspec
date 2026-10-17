# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::RSpec do
  it 'defines a valid gem version' do
    expect(Gem::Version.new(Mongoid::RSpec::VERSION)).to be_a(Gem::Version)
  end
end
