# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::Matchers::Validations::ValidateLengthOfMatcher do
  def length_model(options = {})
    Class.new do
      include Mongoid::Document
      field :name, type: String
      validates_length_of :name, { within: 1..100 }.merge(options)
    end
  end

  %i[nil blank].each do |option|
    full_option = :"allow_#{option}"

    [true, false].each do |value|
      it "matches explicit #{full_option}: #{value} on classes and instances using either key" do
        model = length_model(full_option => value)
        [model, model.new].each do |subject|
          expect(subject).to validate_length_of(:name).within(1..100).to_allow(option => value)
          expect(subject).to validate_length_of(:name).within(1..100).to_allow(full_option => value)
          expect(subject).not_to validate_length_of(:name).within(1..100).to_allow(option => !value)
        end
      end

      it "does not equate absent #{full_option} with #{value}" do
        model = length_model
        [model, model.new].each do |subject|
          expect(subject).not_to validate_length_of(:name).to_allow(option => value)
        end
      end
    end

    it "leaves #{full_option} unchecked without to_allow" do
      [length_model, length_model(full_option => true), length_model(full_option => false)].each do |model|
        expect(model).to validate_length_of(:name).within(1..100)
      end
    end
  end

  it 'accepts combined options without mutating a frozen argument' do
    options = { nil: true, blank: false }.freeze
    matcher = validate_length_of(:name).within(1..100).to_allow(options)
    expect(matcher.matches?(length_model(allow_nil: true, allow_blank: false))).to be true
    expect(options).to eq(nil: true, blank: false)
  end

  it 'merges repeated calls and allows replacing an earlier expectation' do
    matcher = validate_length_of(:name).to_allow(nil: false).to_allow(blank: false).to_allow(allow_nil: true)
    expect(matcher.matches?(length_model(allow_nil: true, allow_blank: false))).to be true
  end

  [nil, true, false, 1, 'nil', [], {}, { unknown: true }, { nil: nil }, { blank: 'true' },
   { 'nil' => true }, { nil: true, unknown: false }, { nil: true, allow_nil: false },
   { blank: true, allow_blank: true }].each do |options|
    it "rejects invalid options #{options.inspect}" do
      expect { validate_length_of(:name).to_allow(options) }.to raise_error(ArgumentError, /to_allow requires/)
    end
  end

  it 'does not partially update expectations after an invalid call' do
    matcher = validate_length_of(:name).to_allow(nil: false)
    expect { matcher.to_allow(nil: true, unknown: true) }.to raise_error(ArgumentError)
    expect(matcher.matches?(length_model(allow_nil: false))).to be true
  end

  it 'reports expected and actual options on failure and success' do
    matcher = validate_length_of(:name).within(1..100).to_allow(nil: true, blank: false)
    expect(matcher.description).to include('with allow_nil true', 'with allow_blank false')
    expect(matcher.matches?(length_model)).to be false
    expect(matcher.failure_message).to include('with allow_nil true', 'with allow_nil nil', 'with allow_blank nil')
    expect(matcher.matches?(length_model(allow_nil: true, allow_blank: false))).to be true
    expect(matcher.failure_message_when_negated).to include('with allow_nil true', 'with allow_blank false')
  end

  it 'can reuse a matcher across matching, mismatching, and missing validators' do
    matcher = validate_length_of(:name).to_allow(nil: true)
    model = length_model(allow_nil: true)
    expect(matcher.matches?(model)).to be true
    expect(matcher.matches?(length_model(allow_nil: false))).to be false
    expect(matcher.matches?(User)).to be false
    expect(matcher.failure_message).to include('no "length" validator')
    expect(matcher.matches?(model.new)).to be true
  end

  context 'with multiple validators' do
    let(:model) do
      Class.new do
        include Mongoid::Document
        field :name, type: String
        validates_length_of :name, within: 1..100, allow_nil: false, allow_blank: true, message: 'first'
        validates_length_of :name, within: 1..100, allow_nil: true, allow_blank: false, message: 'second'
        validates_length_of :name, minimum: 5, allow_nil: true
        validates_length_of :name, maximum: 50, allow_blank: true
        validates_length_of :name, is: 10, allow_blank: true
        validates_length_of :name, within: 2..20, allow_nil: true, on: :create
        validates_length_of :name, within: 3..30, allow_nil: true, if: -> { false }
      end
    end

    it 'finds a later validator with all requested options for classes and instances' do
      [model, model.new].each do |subject|
        expect(subject).to validate_length_of(:name).within(1..100).with_message('second').to_allow(nil: true, blank: false)
        expect(subject).to validate_length_of(:name).with_minimum(1).with_maximum(100).to_allow(nil: true)
        expect(subject).to validate_length_of(:name).as_exactly(10).to_allow(blank: true)
      end
    end

    it 'does not combine allowances, messages, or lengths from different validators' do
      [model, model.new].each do |subject|
        expect(subject).not_to validate_length_of(:name).to_allow(nil: true, blank: true)
        expect(subject).not_to validate_length_of(:name).to_allow(nil: true).with_message('first')
        expect(subject).not_to validate_length_of(:name).with_minimum(5).with_maximum(50).to_allow(nil: true)
        expect(subject).not_to validate_length_of(:name).with_minimum(5).to_allow(blank: true)
        expect(subject).not_to validate_length_of(:name).with_maximum(50).to_allow(nil: true)
        expect(subject).not_to validate_length_of(:name).as_exactly(10).to_allow(nil: true)
      end
    end

    it 'preserves context and condition filtering' do
      expect(model).to validate_length_of(:name).within(2..20).to_allow(nil: true).on(:create)
      expect(model).not_to validate_length_of(:name).within(2..20).to_allow(nil: true).on(:update)
      expect(model.new).to validate_length_of(:name).within(3..30).to_allow(nil: true)
      expect(model.new).not_to validate_length_of(:name).within(3..30).to_allow(nil: true).check_conditions
    end
  end
end
