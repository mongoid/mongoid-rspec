require 'spec_helper'

describe "Document" do
  describe User do
    it { should have_fields(:email, :login) }
  end
  
  describe Article do
    it { should have_field(:published).of_type(Boolean).with_default_value_of(false) }
    it { should have_field(:allow_comments).of_type(Boolean).with_default_value_of(true) }    
    it { should_not have_field(:allow_comments).of_type(Boolean).with_default_value_of(false) }
  end

  describe Article do
    it { should be_mongoid_document }
    it { should be_versioned_document }
    it { should be_timestamped_document }
    it { should be_paranoid_document }
  end
end