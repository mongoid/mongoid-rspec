require 'spec_helper'

describe "AllowMassAssignment" do
  describe User do
    it { should allow_mass_assignment_of(:login) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:age) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:role).as(:admin) }
    
    it { should_not allow_mass_assignment_of(:role) }
  end
end