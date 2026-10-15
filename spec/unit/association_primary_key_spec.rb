# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Association primary keys' do
  let!(:author_class) do
    stub_const('PrimaryKeyAuthor', Class.new do
      include Mongoid::Document

      field :code, type: String
      has_many :articles, class_name: 'PrimaryKeyArticle', primary_key: :code, foreign_key: :author_code, inverse_of: :author
    end)
  end

  let!(:article_class) do
    stub_const('PrimaryKeyArticle', Class.new do
      include Mongoid::Document

      belongs_to :author, class_name: 'PrimaryKeyAuthor', primary_key: 'code', foreign_key: :author_code, inverse_of: :articles
    end)
  end

  shared_examples 'a primary key matcher' do
    it 'accepts symbol and string primary keys on classes and instances' do
      [model, model.new].each do |actual|
        expect(actual).to matcher.with_primary_key(:code)
        expect(actual).to matcher.with_primary_key('code')
      end
    end

    it 'rejects a different primary key on classes and instances' do
      [model, model.new].each do |actual|
        expect(actual).not_to matcher.with_primary_key(:_id)
        expect(actual).not_to matcher.with_primary_key(:author_code)
      end
    end

    it 'chains with other association options' do
      expect(model).to matcher.with_primary_key(:code).with_foreign_key(:author_code).of_type(associated_class).as_inverse_of(inverse)
      expect(model).not_to matcher.with_primary_key(:code).with_foreign_key(:wrong_key)
      expect(model).not_to matcher.with_primary_key(:wrong_key).with_foreign_key(:author_code)
    end

    it 'describes the requested key and reports the actual key on failure' do
      expectation = matcher.with_primary_key(:wrong_key)
      expect(expectation.description).to include('using primary key "wrong_key"')
      expect(expectation.matches?(model)).to be false
      expect(expectation.failure_message).to include('using primary key "wrong_key"', 'with primary key "code"')
    end

    it 'reports the matching key on a negated failure' do
      expectation = matcher.with_primary_key(:code)
      expect(expectation.matches?(model)).to be true
      expect(expectation.failure_message_when_negated).to include('using primary key "code"', 'with primary key "code"')
    end
  end

  context 'with has_many' do
    let(:model) { author_class }
    let(:matcher) { have_many(:articles) }
    let(:associated_class) { article_class }
    let(:inverse) { :author }

    include_examples 'a primary key matcher'
  end

  context 'with belongs_to' do
    let(:model) { article_class }
    let(:matcher) { belong_to(:author) }
    let(:associated_class) { author_class }
    let(:inverse) { :articles }

    include_examples 'a primary key matcher'
  end

  it 'matches the default primary key even without an explicit option' do
    expect(User).to have_many(:articles).with_primary_key(:_id)
    expect(Article.new).to belong_to(:author).with_primary_key('_id')
    expect(User).not_to have_many(:articles).with_primary_key(:code)
    expect(Article).not_to belong_to(:author).with_primary_key(:code)
  end

  it 'still checks association existence and type' do
    expect(author_class).not_to have_many(:missing).with_primary_key(:code)
    expect(author_class).not_to belong_to(:articles).with_primary_key(:code)
  end
end
