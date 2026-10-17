# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Association matcher diagnostics' do
  [
    [User, :have_many, :missing, nil, [], 'no association named missing'],
    [User, :have_one, :articles, nil, [], 'references many'],
    [User, :have_many, :articles, :of_type, [Profile], 'of type Article'],
    [Article, :belong_to, :author, :as_inverse_of, [:other], 'inverse of articles'],
    [User, :have_many, :articles, :ordered_by, [:missing], 'ordered by title'],
    [User, :have_many, :comments, :with_dependent, [:delete], 'dependent as destroy'],
    [User, :have_many, :messages, :with_autosave, [], 'did not set autosave'],
    [User, :embed_one, :profile, :with_autobuild, [], 'did not set autobuild'],
    [Article, :belong_to, :author, :with_polymorphism, [], 'did not set polymorphic'],
    [User, :embed_one, :profile, :with_cascading_callbacks, [], 'did not set cascade_callbacks'],
    [Article, :embed_many, :comments, :cyclic, [], 'did not set cyclic'],
    [Article, :embed_many, :comments, :stored_as, [:other], 'stored as comments'],
    [User, :belong_to, :site, :with_index, [], 'did not set index'],
    [Article, :belong_to, :author, :with_foreign_key, [:other_id], 'foreign key "author_id"'],
    [Article, :belong_to, :author, :with_touch, [false], 'sets touch as true'],
    [Article, :belong_to, :author, :with_optional, [], 'did not set optional']
  ].each do |model, factory, relation, modifier, arguments, message|
    it "explains #{model}.#{relation} mismatches for #{modifier || factory}" do
      matcher = public_send(factory, relation)
      matcher.public_send(modifier, *arguments) if modifier
      expect(matcher.matches?(model)).to be false
      expect(matcher.failure_message).to include(message)
      expect(matcher.description).not_to be_empty
    end
  end

  it 'describes successful matches when negated' do
    matcher = have_many(:comments).of_type(Comment).with_autosave
    expect(matcher.matches?(User.new)).to be true
    expect(matcher.failure_message_when_negated).to include('not', 'of type Comment', 'which set autosave')
  end

  it 'checks cyclic and stored association metadata on real embedded relations' do
    model = Class.new do
      include Mongoid::Document
      embeds_many :comments, cyclic: true, store_as: :notes
    end
    expect(model).to embed_many(:comments).cyclic.stored_as(:notes)
  end

  it 'rejects unknown association types and ordering a singular association' do
    expect { have_one(:record).ordered_by(:name) }.to raise_error(RuntimeError, /does not respond to :order/)
    expect { have_many(:articles).type_description(String) }.to raise_error(RuntimeError, /Unknown association type/)
  end

  if Mongoid::Compatibility::Version.mongoid6_or_older?
    it 'reports associations without a counter cache' do
      matcher = have_many(:articles).with_counter_cache
      expect(matcher.matches?(User)).to be false
      expect(matcher.failure_message).to include('did not set counter_cache')
    end

    it 'explains an ordering direction mismatch on legacy metadata' do
      matcher = have_many(:users).ordered_by(:email.asc)
      expect(matcher.matches?(Site)).to be false
      expect(matcher.failure_message).to include('descending')
    end
  end
end
