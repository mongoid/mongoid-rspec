require 'spec_helper'
if Mongoid::Compatibility::Version.mongoid4_or_newer?
  RSpec.describe Mongoid::Matchers::BeMongoidDocument do
    context 'when model does\'t include Mongoid::Attributes::Dynamic' do
      subject do
        Class.new do
          include Mongoid::Document
        end
      end

      it { is_expected.not_to be_dynamic_document }
    end

    context 'when model doesn\'t include Mongoid::Attributes::Dynamic' do
      subject do
        Class.new do
          include Mongoid::Document
          include Mongoid::Attributes::Dynamic
        end
      end

      it { is_expected.to be_dynamic_document }
    end
  end
end
