require 'spec_helper'

describe "Document" do
  describe User do
    it { should have_fields(:email, :login) }
  end
  
  describe Article do
    it { should have_field(:published).of_type(Boolean).with_default_value_of(false) }
  end  
end