require 'spec_helper'

describe "Collections" do
  describe Log do
    it { should be_stored_in :logs }
  end
end