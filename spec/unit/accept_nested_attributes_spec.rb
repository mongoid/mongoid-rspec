require 'spec_helper'

describe "AcceptsNestedAttributes" do
  describe User do
    it { should accept_nested_attributes_for(:articles) }
    xit { should accept_nested_attributes_for(:comments).limit(1) }
  end

  describe Site do
    xit { should accept_nested_attributes_for(:users).allow_destroy(true) }
  end

  describe Article do
    xit { should accept_nested_attributes_for(:permalink).update_only(true).limit(1) }
  end
end