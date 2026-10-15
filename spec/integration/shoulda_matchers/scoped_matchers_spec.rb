# frozen_string_literal: true

require_relative 'spec_helper'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.define do
  create_table :integration_cities do |table|
    table.string :name
  end
  create_table :integration_addresses do |table|
    table.string :name
    table.integer :city_id
  end
end

class IntegrationCity < ActiveRecord::Base
  has_many :addresses, class_name: 'IntegrationAddress', foreign_key: :city_id, inverse_of: :city
end

class IntegrationAddress < ActiveRecord::Base
  belongs_to :city, class_name: 'IntegrationCity', inverse_of: :addresses
  validates :name, length: { maximum: 255 }
end

class IntegrationMongoidCity
  include Mongoid::Document

  has_many :addresses, class_name: 'IntegrationMongoidAddress', inverse_of: :city
end

class IntegrationMongoidAddress
  include Mongoid::Document

  field :name, type: String
  belongs_to :city, class_name: 'IntegrationMongoidCity', inverse_of: :addresses
  validates :name, length: { maximum: 255 }
end

RSpec.describe IntegrationAddress, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to belong_to(:city).inverse_of(:addresses) }

  it 'resolves shared names to Shoulda matchers' do
    expect(method(:validate_length_of).owner).to eq(Shoulda::Matchers::ActiveModel)
    expect(belong_to(:city)).to be_a(Shoulda::Matchers::ActiveRecord::AssociationMatcher)
  end

  context 'when Mongoid matchers are also included directly' do
    include Mongoid::Matchers

    it 'reproduces the original validation and association collisions' do
      expect { validate_length_of(:name).is_at_most(255) }.to raise_error(NoMethodError, /is_at_most/)
      expect { belong_to(:city).inverse_of(:addresses) }.to raise_error(NoMethodError, /inverse_of/)
    end
  end
end

RSpec.describe IntegrationMongoidAddress, type: :mongoid_model do
  subject { described_class.new }

  it { is_expected.to validate_length_of(:name).with_maximum(255) }
  it { is_expected.to belong_to(:city).as_inverse_of(:addresses) }

  it 'resolves shared names to Mongoid matchers' do
    expect(validate_length_of(:name)).to be_a(Mongoid::Matchers::Validations::ValidateLengthOfMatcher)
    expect(belong_to(:city)).to be_a(Mongoid::Matchers::Associations::HaveAssociationMatcher)
  end
end
