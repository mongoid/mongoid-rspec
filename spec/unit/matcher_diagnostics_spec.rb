# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Matcher diagnostics' do
  it 'explains document and dynamic document mismatches' do
    [be_mongoid_document, be_dynamic_document].each do |matcher|
      expect(matcher.matches?(Object.new)).to be false
      expect(matcher.failure_message).to include('expect Object')
      expect(matcher.failure_message_when_negated).to include('not')
    end
  end

  it 'explains absent nested attributes and negated declarations' do
    matcher = accept_nested_attributes_for(:missing)
    expect(matcher.matches?(User.new)).to be false
    expect(matcher.description).to eq('accepts_nested_attributes_for :missing')
    expect(matcher.failure_message).to eq('Expected User to accept nested attributes for missing (is not declared)')
    expect(matcher.failure_message_when_negated).to eq('Did not expect User to accept nested attributes for missing')
  end

  it 'reports unset field defaults and incorrect aliases' do
    matcher = have_field(:login).with_default_value_of('guest').with_alias(:username)
    expect(matcher.matches?(User)).to be false
    expect(matcher.failure_message).to include('with default not set', 'with alias')
  end

  it 'reports fields without localization' do
    matcher = have_field(:login).localized
    expect(matcher.matches?(User)).to be false
    expect(matcher.failure_message).to include('is not localized "login"')
  end

  it 'reports missing indexes and indexes with incompatible options' do
    matcher = have_index_for(missing: 1)
    expect(matcher.matches?(User)).to be_falsey
    expect(matcher.failure_message).to include('found no index')

    matcher = have_index_for(title: 1).with_options(unique: false)
    expect(matcher.matches?(Article)).to be_falsey
    expect(matcher.failure_message).to include('including options', 'unique')
    expect(matcher.failure_message_when_negated).to include('not', 'title')
  end

  it 'explains timestamp expectations and rejects unsupported phases' do
    matcher = have_timestamps.for(:creating).shortened
    expect(matcher.matches?(User)).to be false
    expect(matcher.failure_message).to include('creating', 'timestamps')
    expect(matcher.failure_message_when_negated).to include('not')
    expect { have_timestamps.for(:deleting) }.to raise_error(RuntimeError, /only for creating or updating/)
    expect { have_timestamps.for(:creating).for(:updating) }.to raise_error(RuntimeError, /already declared/)
  end

  if defined?(Mongo::Monitoring::Global)
    it 'rejects command keys that cannot be normalized' do
      expect { execute_mongodb_command(123 => 'articles') }.to raise_error(ArgumentError, /keys must be Strings or Symbols/)
    end
  end
end
