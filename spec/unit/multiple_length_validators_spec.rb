# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Multiple length validators' do
  let(:model) do
    Class.new do
      include Mongoid::Document
      field :password, type: String
      validates_length_of :password, maximum: 72
      validates_length_of :password, minimum: 8
      validates_length_of :password, within: 10..20
      validates_length_of :password, is: 12
      validates_length_of :password, minimum: 8, message: 'too short'
      validates_length_of :password, minimum: 9, if: :requires_password?
      validates_length_of :password, minimum: 6, on: :create
      validates_length_of :password, minimum: 7, on: :update

      def requires_password?
        false
      end
    end
  end

  it 'finds a minimum after a maximum-only validator' do
    expect(model).to validate_length_of(:password).with_minimum(8)
    expect(model.new).to validate_length_of(:password).with_minimum(8)
  end

  it 'finds a maximum, range, and exact length' do
    expect(model).to validate_length_of(:password).with_maximum(72)
    expect(model).to validate_length_of(:password).within(10..20)
    expect(model).to validate_length_of(:password).as_exactly(12)
  end

  it 'checks the message on the same validator as the length' do
    expect(model).to validate_length_of(:password).with_minimum(8).with_message('too short')
    expect(model).not_to validate_length_of(:password).with_minimum(9).with_message('too short')
  end

  it 'does not combine limits from separate validators' do
    expect(model).not_to validate_length_of(:password).with_minimum(8).with_maximum(72)
    expect(model).not_to validate_length_of(:password).within(8..72)
  end

  it 'rejects an absent length and retains useful failure output' do
    matcher = validate_length_of(:password).with_minimum(7)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include('with no minimum')
  end

  it 'honors conditional validation opt-in' do
    expect(model.new).to validate_length_of(:password).with_minimum(9)
    expect(model.new).not_to validate_length_of(:password).with_minimum(9).check_conditions
  end

  it 'honors requested validation contexts' do
    expect(model).to validate_length_of(:password).with_minimum(6).on(:create)
    expect(model).to validate_length_of(:password).with_minimum(7).on(:update)
    expect(model).not_to validate_length_of(:password).with_minimum(7).on(:create)
  end

  it 'can reuse a matcher without retaining the previous validator' do
    matcher = validate_length_of(:password).with_minimum(8)
    expect(matcher.matches?(model)).to be true
    expect(matcher.matches?(User)).to be false
    expect(matcher.matches?(model.new)).to be true
    expect(matcher.instance_variables).not_to include(:@validator)
  end
end
