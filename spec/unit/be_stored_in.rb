require 'spec_helper'

RSpec.describe Mongoid::Matchers::BeStoredIn do
  subject do
    Class.new do
      include Mongoid::Document
      store_in collection: 'citizens', database: 'other', client: 'secondary'
    end
  end

  it 'detects storage options' do
    is_expected.to be_stored_in(collection: 'citizens', database: 'other', client: 'secondary')
  end

  it 'detects even part of storage options' do
    is_expected.to be_stored_in(database: 'other')
    is_expected.to be_stored_in(client: 'secondary')
    is_expected.to be_stored_in(collection: 'citizens')
    is_expected.to be_stored_in(collection: 'citizens', database: 'other')
    is_expected.to be_stored_in(database: 'other', client: 'secondary')
    is_expected.to be_stored_in(collection: 'citizens', client: 'secondary')
  end

  it 'detects differences' do
    is_expected.not_to be_stored_in(collection: 'aliens')
  end

  context 'when models has storage options defined via blocks, procs or lambdas' do
    subject do
      Class.new do
        include Mongoid::Document
        store_in database: -> { Thread.current[:database] }
      end
    end

    before do
      Thread.current[:database] = 'db1981'
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
