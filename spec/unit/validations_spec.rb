require 'spec_helper'

describe "Validations" do
  describe User do
    it { should validate_presence_of(:login) }
    it { should validate_uniqueness_of(:login) }    
    it { should validate_format_of(:login).to_allow("valid_login").not_to_allow("invalid login") }
    it { should validate_associated(:profile) }
    it { should validate_inclusion_of(:role).to_allow("admin", "member") }
  end
  
  describe Profile do
    it { should validate_numericality_of(:age) }
  end
end