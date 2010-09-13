mongoid-rspec
=

RSpec matchers for Mongoid.


Association Matchers
-
    describe User do
      it { should reference_many :articles }
      it { should reference_many :comments }    
      it { should embed_one :profile }
      it { should reference_many(:children).stored_as(:array) }
    end
  
    describe Profile do
      it { should be_embedded_in(:user).as_inverse_of(:profile) }
    end
  
    describe Article do
      it { should be_referenced_in(:user).as_inverse_of(:articles) }
      it { should embed_many(:comments) }
    end
  
    describe Comment do
      it { should be_embedded_in(:article).as_inverse_of(:comments) }
      it { should be_referenced_in(:user).as_inverse_of(:comments) }
    end

Validation Matchers
-
    describe User do
      it { should validate_presence_of(:login) }
      it { should validate_uniqueness_of(:login) }    
      it { should validate_format_of(:login).to_allow("valid_login").not_to_allow("invalid login") }
      it { should validate_associated(:profile) }
      it { should validate_inclusion_of(:role).to_allow("admin", "member") }
      it { should validate_numericality_of(:age) }
    end
    
    describe Article do
      it { should validate_length_of(:title) }
    end

Others
-
    describe User do
      it { should have_fields(:email, :login) }
      it { should have_field(:active).of_type(Boolean).with_default_value_of(false) }
      it { should have_fields(:birthdate, :registered_at).of_type(DateTime) }

      # useful if you use factory_girl and have Factory(:user) defined for User
      it { should save }
    end

Use
-
add in Gemfile

    gem 'mongoid-rspec'
    
drop in existing or dedicated support file in spec/support (spec/support/mongoid.rb)

    RSpec.configure do |configuration|
      configuration.include Mongoid::Matchers
    end
