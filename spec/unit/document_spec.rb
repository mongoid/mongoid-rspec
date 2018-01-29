require 'spec_helper'

RSpec.describe 'Document' do
  describe User do
    it { is_expected.to have_fields(:email, :login) }
  end

  describe Article do
    klass_boolean = Mongoid::Compatibility::Version.mongoid4_or_newer? ? Mongoid::Boolean : Boolean
    it { is_expected.to have_field(:published).of_type(klass_boolean).with_default_value_of(false) }
    it { is_expected.to have_field(:allow_comments).of_type(klass_boolean).with_default_value_of(true) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_field(:title).localized }
    it { is_expected.not_to have_field(:allow_comments).of_type(klass_boolean).with_default_value_of(false) }
    it { is_expected.not_to have_field(:number_of_comments).of_type(Integer).with_default_value_of(1) }
  end
end
