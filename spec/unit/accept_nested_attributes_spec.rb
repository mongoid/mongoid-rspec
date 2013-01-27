require 'spec_helper'

describe "AcceptsNestedAttributes" do
  describe User do
    it { should accept_nested_attributes_for(:articles) }
    it { should accept_nested_attributes_for(:comments) }
  end

  describe Article do
    it { should accept_nested_attributes_for(:permalink) }
  end
end