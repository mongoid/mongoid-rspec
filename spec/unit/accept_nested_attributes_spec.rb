require 'spec_helper'

RSpec.describe 'AcceptsNestedAttributes' do
  describe User do
    it { is_expected.to accept_nested_attributes_for(:articles) }
    it { is_expected.to accept_nested_attributes_for(:comments) }
  end

  describe Article do
    it { is_expected.to accept_nested_attributes_for(:permalink) }
  end
end
