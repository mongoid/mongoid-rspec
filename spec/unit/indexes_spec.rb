require 'spec_helper'

describe "Indexes" do
  describe Article do
    it { should have_index_for(published: 1) }
    it { should have_index_for(title: 1).with_options(unique: true, background: true) }
    it { should have_index_for('permalink._id' => 1) }
  end
  
  describe Profile do
    it { should have_index_for(first_name: 1, last_name: 1) }
  end
end