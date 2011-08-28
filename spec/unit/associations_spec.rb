require 'spec_helper'

describe "Associations" do
  describe User do
    it { should reference_many(:articles).with_foreign_key(:author_id) }
    it { should have_many(:articles).with_foreign_key(:author_id) }
    
    it { should reference_one(:record) }
    it { should have_one(:record) }    
    
    it { should reference_many(:comments).with_dependent(:destroy).with_autosave }
    it { should have_many(:comments).with_dependent(:destroy).with_autosave }
    
    it { should embed_one :profile }
    
    it { should reference_and_be_referenced_in_many(:children).of_type(User) }
    it { should have_and_belong_to_many(:children) }
  end

  describe Profile do
    it { should be_embedded_in(:user).as_inverse_of(:profile) }
  end

  describe Article do
    it { should be_referenced_in(:author).of_type(User).as_inverse_of(:articles) }
    it { should belong_to(:author).of_type(User).as_inverse_of(:articles).with_index }
    it { should embed_many(:comments) }
    it { should embed_one(:permalink) }    
  end

  describe Comment do
    it { should be_embedded_in(:article).as_inverse_of(:comments) }
    it { should be_referenced_in(:user).as_inverse_of(:comments) }
  end
  
  describe Record do
    it { should be_referenced_in(:user).as_inverse_of(:record) }
  end

  describe Permalink do
    it { should be_embedded_in(:linkable).as_inverse_of(:link) }
  end

  describe Site do
    it { should reference_many(:users).as_inverse_of(:site) }
  end
end
