# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::Matchers::HaveIndexFor do
  subject do
    Class.new do
      include Mongoid::Document

      field :fizz, as: :buzz, type: String

      index(foo: 1)
      index({ bar: 1 }, unique: true, background: true)
      index(foo: 1, bar: -1)
      index('baz._id' => 1)
      index(buzz: 1)
    end
  end

  it 'detects an index for singular field key' do
    is_expected.to have_index_for(foo: 1)
  end

  it 'detects an index for multipple fields key' do
    is_expected.to have_index_for(foo: 1, bar: -1)
  end

  it 'detects an index with options' do
    is_expected
      .to have_index_for(bar: 1)
      .with_options(unique: true, background: true)
  end

  it 'detects an index with only part of options' do
    is_expected
      .to have_index_for(bar: 1)
      .with_options(unique: true)
  end

  it 'detects an index for string key' do
    is_expected.to have_index_for('baz._id' => 1)
  end

  it 'detect an index for aliased fields' do
    is_expected.to have_index_for(fizz: 1)
    is_expected.to have_index_for(buzz: 1) if Mongoid::Compatibility::Version.mongoid4_or_newer?
  end

  if Mongoid::Compatibility::Version.mongoid4_or_newer?
    context 'with a compound index on aliased fields' do
      subject do
        Class.new do
          include Mongoid::Document

          field :o, as: :operator_id, type: Integer
          field :c, as: :conversation_id, type: String
          field :m, as: :conversation_message_id, type: String

          index({ operator_id: 1, conversation_id: 1 }, background: true)
        end
      end

      it 'matches aliased names and options on a class' do
        expect(subject).to have_index_for(operator_id: 1, conversation_id: 1).with_options(background: true)
      end

      it 'matches stored names and options on an instance' do
        expect(subject.new).to have_index_for(o: 1, c: 1).with_options(background: true)
      end

      it 'rejects a different field, order, direction, or option' do
        expect(subject).not_to have_index_for(operator_id: 1, conversation_message_id: 1)
        expect(subject).not_to have_index_for(conversation_id: 1, operator_id: 1)
        expect(subject).not_to have_index_for(operator_id: 1, conversation_id: -1)
        expect(subject).not_to have_index_for(operator_id: 1, conversation_id: 1).with_options(unique: true)
      end
    end
  end
end
