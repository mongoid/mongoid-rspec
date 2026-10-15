# frozen_string_literal: true

require 'spec_helper'

class CoveredQuerySpecDocument
  include Mongoid::Document

  field :name, type: String
  field :category, type: String

  index(name: 1, _id: 1)
end

RSpec.describe Mongoid::Matchers::BeCoveredQuery do
  def criteria_with_plan(plan)
    Struct.new(:plan) do
      def explain
        plan
      end
    end.new(plan)
  end

  if Mongoid::Compatibility::Version.mongoid5_or_newer?
    before(:all) do
      CoveredQuerySpecDocument.collection.drop
      CoveredQuerySpecDocument.create_indexes
      100.times do |number|
        CoveredQuerySpecDocument.create!(name: "name-#{number}", category: 'example')
      end
    end

    it 'matches an indexed query whose projected fields are covered' do
      criteria = CoveredQuerySpecDocument.where(name: 'name-1').only(:name)

      expect(criteria).to be_covered_query
      expect(criteria).to be_covered_query.using_index('name_1__id_1')
      expect(criteria).not_to be_covered_query.using_index('category_1')
    end

    it 'rejects an index scan that fetches documents' do
      criteria = CoveredQuerySpecDocument.where(name: 'name-1').hint(name: 1, _id: 1)

      expect(criteria.explain.dig('queryPlanner', 'winningPlan')).to include('stage' => 'FETCH')
      expect(criteria).not_to be_covered_query
      expect(criteria).not_to be_covered_query.using_index('name_1__id_1')
    end

    it 'rejects a collection scan' do
      criteria = CoveredQuerySpecDocument.where(name: 'name-1').only(:name).hint('$natural' => 1)

      expect(criteria.explain.dig('queryPlanner', 'winningPlan')).to include('stage' => 'PROJECTION_SIMPLE')
      expect(criteria).not_to be_covered_query
    end
  end

  it 'checks stages nested in shard plans' do
    plan = {
      'queryPlanner' => {
        'winningPlan' => {
          'stage' => 'SHARD_MERGE',
          'shards' => [
            { 'winningPlan' => { 'stage' => 'PROJECTION_COVERED', 'inputStage' => { 'stage' => 'IXSCAN' } } },
            { 'winningPlan' => { 'stage' => 'PROJECTION_COVERED', 'inputStage' => { 'stage' => 'IXSCAN' } } }
          ]
        }
      }
    }
    criteria = criteria_with_plan(plan)

    expect(criteria).to be_covered_query
  end

  it 'rejects a fetch in any shard plan' do
    plan = {
      'queryPlanner' => {
        'winningPlan' => {
          'stage' => 'SHARD_MERGE',
          'shards' => [
            { 'winningPlan' => { 'stage' => 'PROJECTION_COVERED', 'inputStage' => { 'stage' => 'IXSCAN' } } },
            { 'winningPlan' => { 'stage' => 'FETCH', 'inputStage' => { 'stage' => 'IXSCAN' } } }
          ]
        }
      }
    }
    criteria = criteria_with_plan(plan)

    expect(criteria).not_to be_covered_query
  end

  it 'does not interpret a query field named stage as a plan stage' do
    plan = {
      'queryPlanner' => {
        'winningPlan' => {
          'stage' => 'EOF',
          'filter' => { 'stage' => 'IXSCAN' }
        }
      }
    }

    expect(criteria_with_plan(plan)).not_to be_covered_query
  end

  def indexed_plan(*names)
    {
      'queryPlanner' => {
        'winningPlan' => {
          'stage' => 'SHARD_MERGE',
          'shards' => names.map do |name|
            { 'winningPlan' => { 'stage' => 'IXSCAN', 'indexName' => name } }
          end
        },
        'rejectedPlans' => [{ 'stage' => 'IXSCAN', 'indexName' => 'rejected' }]
      }
    }
  end

  it 'matches the exact index set regardless of order and repeated shard scans' do
    criteria = criteria_with_plan(indexed_plan('second', 'first', 'first'))

    expect(criteria).to be_covered_query.using_indexes(:first, 'second', 'first')
    expect(criteria).not_to be_covered_query.using_index('first')
    expect(criteria).not_to be_covered_query.using_indexes('first', 'second', 'third')
    expect(criteria).not_to be_covered_query.using_indexes('first', 'second', 'rejected')
  end

  it 'accepts repeated uses of a single index' do
    expect(criteria_with_plan(indexed_plan('first', 'first'))).to be_covered_query.using_index(:first)
  end

  it 'does not treat non-scan index names as used indexes' do
    plan = indexed_plan('first')
    plan['queryPlanner']['winningPlan']['indexName'] = 'not_a_scan'

    expect(criteria_with_plan(plan)).to be_covered_query.using_index('first')
  end

  it 'supports symbol keys in winning plans' do
    plan = { queryPlanner: { winningPlan: { stage: 'IXSCAN', indexName: 'first' } } }

    expect(criteria_with_plan(plan)).to be_covered_query.using_index('first')
  end

  it 'rejects unnamed scans when index names are requested' do
    expect(criteria_with_plan(indexed_plan('first', nil))).not_to be_covered_query.using_index('first')
  end

  it 'resets observed indexes when reused' do
    matcher = be_covered_query.using_index('first')

    expect(matcher.matches?(criteria_with_plan(indexed_plan('first')))).to be true
    expect(matcher.matches?(criteria_with_plan(indexed_plan('second')))).to be false
    expect(matcher.failure_message).to include('indexes were ["second"]')
    expect(matcher.matches?(criteria_with_plan(indexed_plan('first')))).to be true
    expect(matcher.matches?(Object.new)).to be false
    expect(matcher.failure_message).to include('no winning plan was found')
  end

  it 'describes expected indexes in positive and negated failures' do
    matcher = be_covered_query.using_indexes('second', 'first')
    matcher.matches?(criteria_with_plan(indexed_plan('other')))

    expect(matcher.description).to eq('be a covered query using indexes ["first", "second"]')
    expect(matcher.failure_message).to include('using indexes ["first", "second"]')
    expect(matcher.failure_message).to include('indexes were ["other"]')
    expect(matcher.failure_message_when_negated).to include('not to be a covered query using indexes ["first", "second"]')
  end

  it 'rejects empty or invalid index names' do
    expect { be_covered_query.using_indexes }.to raise_error(ArgumentError)
    [nil, '', 123, [], {}].each do |name|
      expect { be_covered_query.using_index(name) }.to raise_error(ArgumentError)
      expect { be_covered_query.using_indexes('first', name) }.to raise_error(ArgumentError)
    end
  end
end
