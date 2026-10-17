# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Legacy mass-assignment compatibility' do
  # Rails removed this API in Rails 4. Model doubles expose only its historical
  # authorizer contract; matcher behavior is still exercised through public APIs.
  let(:whitelist_class) do
    Class.new(Set) do
      def deny?(attribute)
        !include?(attribute)
      end
    end
  end
  let(:blacklist_class) do
    Class.new(Set) do
      def deny?(attribute)
        include?(attribute)
      end
    end
  end
  let(:model) { Class.new.new }

  before do
    stub_const('ActiveModel::MassAssignmentSecurity::WhiteList', whitelist_class)
    allow(model.class).to receive(:accessible_attributes).and_return([])
    allow(model.class).to receive(:protected_attributes).and_return([])
    allow(model.class).to receive(:name).and_return('LegacyAccount')
  end

  it 'checks a whitelist and explains both positive and negative results' do
    allow(model.class).to receive(:active_authorizer).and_return(default: whitelist_class.new(['name']))
    matcher = allow_mass_assignment_of(:name)
    expect(matcher.matches?(model)).to be true
    expect(matcher.description).to eq('allow mass assignment of name')
    expect(matcher.failure_message_when_negated).to eq('name was made accessible')
    matcher = allow_mass_assignment_of(:password)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to eq('Expected password to be accessible')
  end

  it 'checks default and explicit roles' do
    allow(model.class).to receive(:active_authorizer).and_return(
      default: whitelist_class.new, admin: whitelist_class.new(['password'])
    )
    expect(model).not_to allow_mass_assignment_of(:password)
    expect(model).to allow_mass_assignment_of(:password).as(:admin)
  end

  it 'reports a protected attribute and the attributes that remain assignable' do
    allow(model.class).to receive(:active_authorizer).and_return(default: blacklist_class.new(['password']))
    allow(model.class).to receive(:protected_attributes).and_return(Set.new(['password']))
    matcher = allow_mass_assignment_of(:password)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to eq('Did not expect password to be protected')
    matcher = allow_mass_assignment_of(:name)
    expect(matcher.matches?(model)).to be true
    expect(matcher.failure_message_when_negated).to eq('LegacyAccount is protecting password, but not name.')
  end

  it 'explains an empty blacklist' do
    allow(model.class).to receive(:active_authorizer).and_return(default: blacklist_class.new)
    matcher = allow_mass_assignment_of(:name)
    expect(matcher.matches?(model)).to be true
    expect(matcher.failure_message_when_negated).to eq('no attributes were protected')
  end

  it 'supports the pre-3.1 authorizer and rejects roles on that version' do
    stub_const('ActiveModel::VERSION::STRING', '3.0.0')
    allow(model.class).to receive(:active_authorizer).and_return(whitelist_class.new(['name']))
    expect(model).to allow_mass_assignment_of(:name)
    expect { allow_mass_assignment_of(:name).as(:admin) }.to raise_error(RuntimeError, /Rails 3.1 or greater/)
  end
end

RSpec.describe 'Mongoid 3 index compatibility' do
  let(:model) do
    Class.new do
      def self.index_options
        { { name: 1 } => { unique: true, dropDups: true } }
      end
    end
  end

  before do
    # Isolate the historical implementation from the matcher selected for the
    # current Mongoid. index_options was replaced by index_specification in v4.
    stub_const('Mongoid::Matchers::HaveIndexFor', Class.new(Mongoid::Matchers::HaveIndexForBase))
    load File.expand_path('../../lib/matchers/indexes/v3/have_index_for.rb', __dir__)
  end

  it 'matches indexes, normalizes historical options and explains missing or incompatible indexes' do
    expect(model).to have_index_for('name' => 1)
    expect(model.new).to have_index_for(name: 1).with_options(unique: true, drop_dups: true)
    expect(model).to have_index_for(name: 1).with_options({})

    matcher = have_index_for(missing: 1)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include('no index for', 'missing')

    matcher = have_index_for(name: 1).with_options(unique: false)
    expect(matcher.matches?(model)).to be false
    expect(matcher.failure_message).to include('with options of', 'unique', 'true')
    expect(matcher.failure_message_when_negated).to include('not', 'unique', 'false')
  end
end
