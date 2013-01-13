require 'spec_helper'

describe "Document" do
  describe User do
    it { should have_fields(:email, :login) }
    it { should be_timestamped_document }
    it { should be_timestamped_document.with(:created) }
    it { should_not be_timestamped_document.with(:updated) }
  end

  describe Article do
    it { should have_field(:published).of_type(Boolean).with_default_value_of(false) }
    it { should have_field(:allow_comments).of_type(Boolean).with_default_value_of(true) }
    it { should belong_to(:author) }
    it { should have_field(:title).localized }
    it { should_not have_field(:allow_comments).of_type(Boolean).with_default_value_of(false) }
    it { should_not have_field(:number_of_comments).of_type(Integer).with_default_value_of(1) }
    it { should be_mongoid_document }
    it { should be_versioned_document }
    it { should be_timestamped_document }
    it { should be_paranoid_document }
    it { should be_multiparameted_document }
  end
end
