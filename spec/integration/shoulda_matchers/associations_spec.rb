# frozen_string_literal: true

require_relative 'spec_helper'

class IntegrationAssociationDocument
  include Mongoid::Document

  has_and_belongs_to_many :children, class_name: 'IntegrationAssociationDocument'
end

RSpec.describe 'Coexistence with shoulda-matchers', type: :mongoid_model do
  include Shoulda::Matchers::ActiveRecord

  it 'reproduces the original association matcher name collision' do
    matcher = have_and_belong_to_many(:children)

    expect(matcher).to be_a(Shoulda::Matchers::ActiveRecord::AssociationMatcher)
    expect(matcher).not_to be_a(Mongoid::Matchers::Associations::HaveAssociationMatcher)
    expect { matcher.of_type(IntegrationAssociationDocument) }.to raise_error(NoMethodError, /of_type/)
  end

  it 'provides the Mongoid matcher through the related name for instance subjects' do
    expect(IntegrationAssociationDocument.new).to have_and_belong_to_many_related(:children).of_type(IntegrationAssociationDocument)
    expect(IntegrationAssociationDocument.new).not_to have_and_belong_to_many_related(:articles)
  end

  it 'provides the Mongoid matcher through the related name for class subjects' do
    expect(IntegrationAssociationDocument).to have_and_belong_to_many_related(:children).of_type(IntegrationAssociationDocument)
    expect(IntegrationAssociationDocument).not_to have_and_belong_to_many_related(:children).of_type(String)
  end
end
