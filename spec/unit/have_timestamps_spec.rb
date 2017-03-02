require 'spec_helper'

RSpec.describe Mongoid::Matchers::HaveTimestamps do
  context 'when model includes Mongoid::Timestamps' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps
      end
    end

    it { is_expected.to have_timestamps }
  end

  context 'when model includes Mongoid::Timestamps::Short' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps::Short
      end
    end

    it { is_expected.to have_timestamps.shortened }
  end

  context 'when model includes Mongoid::Timestamps::Updated' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps::Updated
      end
    end

    it { is_expected.to have_timestamps.for(:updating) }
  end

  context 'when model includes Mongoid::Timestamps::Updated::Short' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps::Updated::Short
      end
    end

    it { is_expected.to have_timestamps.for(:updating).shortened }
    it { is_expected.to have_timestamps.shortened.for(:updating) }
  end

  context 'when model includes Mongoid::Timestamps::Created' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps::Created
      end
    end

    it { is_expected.to have_timestamps.for(:creating) }
  end

  context 'when model includes Mongoid::Timestamps::Created::Short' do
    subject do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps::Created::Short
      end
    end

    it { is_expected.to have_timestamps.for(:creating).shortened }
    it { is_expected.to have_timestamps.shortened.for(:creating) }
  end
end
