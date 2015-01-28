require 'spec_helper'

RSpec.describe "Collections" do
  describe Log do
    it { is_expected.to be_stored_in :logs }
  end
end
