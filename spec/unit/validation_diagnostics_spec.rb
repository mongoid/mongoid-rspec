# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Validation matcher diagnostics' do
  def expect_mismatch(model, matcher, message)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include(message)
  end

  it 'checks explicit format, allowed values, and forbidden values' do
    expect(User).to validate_format_of(:login).with_format(/\A[\w\-]+\z/)
    expect_mismatch(User, validate_format_of(:login).with_format(/\A\d+\z/), 'with format')
    expect_mismatch(User, validate_format_of(:login).to_allow('!'), 'as an invalid value')
    expect_mismatch(User, validate_format_of(:login).not_to_allow('valid'), 'as a valid value')
    expect_mismatch(User, validate_format_of(:login).with_message('different').to_allow('valid'), 'no custom message')
  end

  it 'reports values outside inclusion and exclusion constraints' do
    expect_mismatch(User, validate_inclusion_of(:role).to_allow('owner'), 'not allowing these values')
    expect_mismatch(User, validate_exclusion_of(:login).to_not_allow('available'), 'allowing the following')
    model = Class.new do
      include Mongoid::Document
      field :age, type: Integer
      validates :age, exclusion: { in: 1..3 }
    end
    stub_const('CoverageExclusionRecord', model)
    expect(model).to validate_exclusion_of(:age).to_not_allow(1, 2, 3)
    expect(model.new(age: 2)).not_to be_valid
    expect(model.new(age: 4)).to be_valid
  end

  it 'checks blank allowance, scope and case sensitivity of uniqueness validators' do
    model = Class.new do
      include Mongoid::Document
      field :name
      validates :name, uniqueness: { allow_blank: true }
    end
    matcher = validate_uniqueness_of(:name).allow_blank?(true)
    expect(matcher.matches?(model)).to be true
    expect(matcher.description).to include('allowing blank values')
    expect(matcher.failure_message_when_negated).to include('with blank values allowed')
    expect_mismatch(User, validate_uniqueness_of(:login).allow_blank?(true), 'no blank values allowed')
    expect_mismatch(User, validate_uniqueness_of(:login).scoped_to(:other), 'scope to site')
    expect_mismatch(User, validate_uniqueness_of(:login).case_insensitive, 'without case insensitive values')
    expect_mismatch(User, validate_uniqueness_of(:email).with_message('different'), 'is already taken')
  end

  it 'explains length ranges with neither or only one bound' do
    model = Class.new do
      include Mongoid::Document
      field :minimum_only
      field :maximum_only
      field :exact_only
      validates :minimum_only, length: { minimum: 2 }
      validates :maximum_only, length: { maximum: 5 }
      validates :exact_only, length: { is: 3 }
    end
    %i[minimum_only maximum_only exact_only].each do |field|
      expect_mismatch(model, validate_length_of(field).within(2..5), 'with')
    end
  end

  it 'rejects invalid numericality options and unknown fluent methods' do
    [{}, { unsupported: true }].each do |options|
      expect { validate_numericality_of(:age).to_allow(options) }.to raise_error(ArgumentError, /requires a Hash/)
    end
    expect { validate_numericality_of(:age).greater_than(1, 2) }.to raise_error(ArgumentError, /wrong number/)
    expect { validate_numericality_of(:age).unknown_comparator(1) }.to raise_error(NoMethodError)
  end

  it 'rejects an unexpected custom validator type' do
    expect_mismatch(Person, custom_validate(:ssn).with_validator(ActiveModel::Validations::PresenceValidator), 'custom validator not of type')
  end

  it 'rejects unsupported conditional validator filters' do
    model = Class.new do
      include Mongoid::Document
      field :name
    end
    # Newer ActiveModel rejects malformed conditions during declaration, so
    # supply validator metadata directly to exercise the matcher's guard.
    validator = ActiveModel::Validations::PresenceValidator.new(attributes: [:name], if: 'unsupported')
    allow(model).to receive(:validators_on).with('name').and_return([validator])
    expect { validate_presence_of(:name).check_conditions.matches?(model.new) }.to raise_error(ArgumentError, /Unexpected filter/)
  end
end
