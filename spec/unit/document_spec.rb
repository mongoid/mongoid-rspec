require 'spec_helper'

RSpec.describe "Document" do
  describe User do
    it { is_expected.to have_fields(:email, :login) }
    it { is_expected.to be_timestamped_document }
    it { is_expected.to be_timestamped_document.with(:created) }
    it { is_expected.not_to be_timestamped_document.with(:updated) }
  end

  describe Article do
    it { is_expected.to have_field(:published).of_type(Mongoid::Boolean).with_default_value_of(false) }
    it { is_expected.to have_field(:allow_comments).of_type(Mongoid::Boolean).with_default_value_of(true) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_field(:title).localized }
    it { is_expected.not_to have_field(:allow_comments).of_type(Mongoid::Boolean).with_default_value_of(false) }
    it { is_expected.not_to have_field(:number_of_comments).of_type(Integer).with_default_value_of(1) }
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_timestamped_document }
  end

  describe Log do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_dynamic_document }
  end
end
