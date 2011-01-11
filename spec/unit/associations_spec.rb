require 'spec_helper'

describe "Associations" do
  describe User do
    it { should reference_one :article }
    it { should have_one :article }
    it { should reference_many :comments }
    it { should have_many :comments }
    it { should embed_one :profile }
    it { should reference_and_be_referenced_in_many(:children) }
    it { should have_and_belong_to_many(:children) }
  end

  describe Profile do
    it { should be_embedded_in(:user).as_inverse_of(:profile) }
  end

  describe Article do
    it { should be_referenced_in(:user).as_inverse_of(:articles) }
    it { should belong_to(:user).as_inverse_of(:articles) }
    it { should embed_many(:comments) }
  end

  describe Comment do
    it { should be_embedded_in(:article).as_inverse_of(:comments) }
    it { should be_referenced_in(:user).as_inverse_of(:comments) }
  end
end
