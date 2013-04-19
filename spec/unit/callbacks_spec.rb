require 'spec_helper'

describe "Callbacks" do
  describe User do
    it { should callback(:callback1).before(:save) }
    it { should callback(:callback2).after(:save) }
    it { should callback(:callback1, :callback2).before(:validation) }
    it { should callback(:callback3).after(:validation).on(:create) }
  end
end

