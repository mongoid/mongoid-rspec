require 'spec_helper'

describe "Indexes" do
  describe Article do
    it { should have_index_for(:published) }
    it { should have_index_for(:title).with_options(:unique => true, :background => true) }
  end
  
  describe Profile do
    it { should have_index_for([ [ :first_name, Mongo::ASCENDING ], [ :last_name, Mongo::ASCENDING ] ]) }
  end
end