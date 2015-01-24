require 'spec_helper'

RSpec.describe "Indexes" do
  describe Article do
    it { is_expected.to have_index_for(published: 1) }
    it { is_expected.to have_index_for(title: 1).with_options(unique: true, background: true, dropDups: true) }
    it { is_expected.to have_index_for('permalink._id' => 1) }
  end

  describe Profile do
    it { is_expected.to have_index_for(first_name: 1, last_name: 1) }
  end
end
