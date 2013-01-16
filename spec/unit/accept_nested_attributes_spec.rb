require 'spec_helper'

describe "AcceptsNestedAttributes" do
  describe User do
    it { should accept_nested_attributes_for(:articles) }
  end
end