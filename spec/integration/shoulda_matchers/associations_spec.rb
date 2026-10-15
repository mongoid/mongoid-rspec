# frozen_string_literal: true

require 'spec_helper'
require 'shoulda/matchers'

RSpec.describe 'Coexistence with shoulda-matchers' do
  include Shoulda::Matchers::ActiveRecord

  it 'reproduces the original association matcher name collision' do
    matcher = have_and_belong_to_many(:children)

    expect(matcher).to be_a(Shoulda::Matchers::ActiveRecord::AssociationMatcher)
    expect(matcher).not_to be_a(Mongoid::Matchers::Associations::HaveAssociationMatcher)
    expect { matcher.of_type(User) }.to raise_error(NoMethodError, /of_type/)
  end

  it 'provides the Mongoid matcher through the related name for instance subjects' do
    expect(User.new).to have_and_belong_to_many_related(:children).of_type(User)
    expect(User.new).not_to have_and_belong_to_many_related(:articles)
  end

  it 'provides the Mongoid matcher through the related name for class subjects' do
    expect(User).to have_and_belong_to_many_related(:children).of_type(User)
    expect(User).not_to have_and_belong_to_many_related(:children).of_type(Article)
  end
end
