# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::Matchers::HaveField do
  let(:model) do
    Class.new do
      include Mongoid::Document

      field :code, type: String, default: 'initial'
      field :sequence, type: Integer
      field :name, type: String
      field :s, type: String, as: :status
      attr_readonly :code, :sequence, :s, :missing
    end
  end

  [true, false].each do |class_subject|
    context "with a #{class_subject ? 'class' : 'document'} subject" do
      subject { class_subject ? model : model.new }

      it { is_expected.to have_field(:code).readonly }
      it { is_expected.to have_field('code').readonly }
      it { is_expected.to have_fields(:code, :sequence).readonly }
      it { is_expected.to have_field(:code).of_type(String).with_default_value_of('initial').readonly }
      it { is_expected.to have_field(:s).with_alias(:status).readonly }
      it { is_expected.not_to have_field(:name).readonly }
      it { is_expected.not_to have_fields(:code, :name).readonly }
      it { is_expected.not_to have_field(:missing).readonly }
      it { is_expected.not_to have_field(:unknown).readonly }
      it { is_expected.not_to have_field(:code).readonly.of_type(Integer) }
      it { is_expected.to have_field(:name) }
    end
  end

  it 'describes the readonly constraint' do
    expect(have_field(:code).readonly.description).to eq('have field named "code" marked readonly')
  end

  it 'explains when an existing field is not readonly' do
    matcher = have_field(:name).readonly
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include('marked readonly, got field "name" that is not readonly')
  end

  it 'explains when a readonly declaration has no corresponding field' do
    matcher = have_field(:missing).readonly
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include('no field named "missing"')
  end

  it 'includes the readonly constraint in negated failures' do
    matcher = have_field(:code).readonly
    expect(matcher.matches?(model)).to be true
    expect(matcher.failure_message_when_negated).to include('to not have field named "code" marked readonly')
  end
end
