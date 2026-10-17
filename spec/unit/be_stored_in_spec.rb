# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::Matchers::BeStoredIn do
  let(:connection_option) { Mongoid::Compatibility::Version.mongoid5_or_newer? ? :client : :session }
  let(:connection_storage) { { connection_option => 'secondary' } }

  subject do
    storage_options = { collection: 'citizens', database: 'other' }.merge(connection_storage)
    Class.new do
      include Mongoid::Document
      store_in storage_options
    end
  end

  it 'detects storage options' do
    is_expected.to be_stored_in({ collection: 'citizens', database: 'other' }.merge(connection_storage))
  end

  it 'detects even part of storage options' do
    is_expected.to be_stored_in(database: 'other')
    is_expected.to be_stored_in(connection_storage)
    is_expected.to be_stored_in(collection: 'citizens')
    is_expected.to be_stored_in(collection: 'citizens', database: 'other')
    is_expected.to be_stored_in({ database: 'other' }.merge(connection_storage))
    is_expected.to be_stored_in({ collection: 'citizens' }.merge(connection_storage))
  end

  it 'detects differences' do
    is_expected.not_to be_stored_in(collection: 'aliens')
  end

  # Dynamic storage matching uses persistence_context, introduced in Mongoid 6.
  if Mongoid::Compatibility::Version.mongoid6_or_newer?
    context 'when models have storage options defined via blocks, procs or lambdas' do
      subject do
        Class.new do
          include Mongoid::Document
          store_in database: -> { Thread.current[:database] }
        end
      end

      before do
        Thread.current[:database] = 'db1981'
      end

      after do
        Thread.current[:database] = nil
      end

      it 'detects storage options' do
        is_expected.to be_stored_in(database: 'db1981')
      end

      it 'reflects changes in storage options' do
        is_expected.to be_stored_in(database: 'db1981')
        Thread.current[:database] = 'db2200'
        is_expected.to be_stored_in(database: 'db2200')
      end

      it 'detects differences' do
        is_expected.not_to be_stored_in(database: 'other')
      end
    end
  end

  it 'describes mismatched storage and negated expectations' do
    matcher = be_stored_in(collection: 'aliens')
    expect(matcher.matches?(subject.new)).to be false
    expect(matcher.failure_message).to include('be stored in', 'aliens', 'citizens')
    expect(matcher.failure_message_when_negated).to include('not to be stored in', 'citizens')
  end

  it 'compares non-symbolizable storage options without changing their values' do
    model = Class.new do
      include Mongoid::Document
      store_in collection: nil
    end
    expect(model).to be_stored_in(collection: nil)
  end
end
