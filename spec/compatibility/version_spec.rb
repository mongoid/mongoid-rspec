require 'spec_helper'

RSpec.describe Mongoid::Compatibility::Version do

  context "current version #{Mongoid::VERSION}" do
    let(:version) { Mongoid::VERSION.split('.').first.to_i }

    it 'has a version' do
      expect(Mongoid::Compatibility::VERSION).not_to be_nil
    end
    
    it 'mongoidX?' do
      expect(Mongoid::Compatibility::Version.send("mongoid#{version}?")).to be true
      expect(Mongoid::Compatibility::Version.send("mongoid6?")).to be true
    end

    it 'mongoidX?_or_newer?' do
      if Mongoid::Compatibility::Version.respond_to?("mongoid#{version - 1}_or_newer?")
        expect(Mongoid::Compatibility::Version.send("mongoid#{version - 1}_or_newer?")).to be true
      end
      if Mongoid::Compatibility::Version.respond_to?("mongoid#{version - 1}_or_older?")
        expect(Mongoid::Compatibility::Version.send("mongoid#{version - 1}_or_older?")).to be false
      end
      if Mongoid::Compatibility::Version.respond_to?("mongoid#{version + 1}_or_older?")
        expect(Mongoid::Compatibility::Version.send("mongoid#{version + 1}_or_older?")).to be true
      end
      if Mongoid::Compatibility::Version.respond_to?("mongoid#{version + 1}_or_newer?")
        expect(Mongoid::Compatibility::Version.send("mongoid#{version + 1}_or_newer?")).to be false
      end
    end
  end
  
end 