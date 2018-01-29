require 'spec_helper'

RSpec.describe Mongoid::Matchers::BeDynamicDocument do
  context 'when model does\'t include Mongoid::Document' do
    subject do
      Class.new
    end

    it { is_expected.not_to be_mongoid_document }
  end

  context 'when model doesn\'t include Mongoid::Document' do
    subject do
      Class.new do
        include Mongoid::Document
      end
    end

    it { is_expected.to be_mongoid_document }
  end
end
