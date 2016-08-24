# [mongoid-rspec]

[![Build Status][travis_badge]][travis]
[![Gem Version][rubygems_badge]][rubygems]
[![Code Climate][codeclimate_badge]][codeclimate]

mongoid-rspec provides a collection of RSpec-compatible matchers that help to test Mongoid documents.

## Installation

### With Mongoid 5.x or 6.x

Use mongoid-rspec [3.1.0][mongoid5]

    gem 'mongoid-rspec', '~> 3.1.0'

### With Mongoid 4.x

Use mongoid-rspec [2.1.0][mongoid4]

    gem 'mongoid-rspec', '~> 2.1.0'

### With Mongoid 3.x

Use mongoid-rspec [1.13.0][mongoid3].

    gem 'mongoid-rspec', '~> 1.13.0'

### With Mongoid 2.x

Use mongoid-rspec [1.4.5][mongoid2]

    gem 'mongoid-rspec', '1.4.5'

### Configuring

Drop in existing or dedicated support file in spec/support.
i.e: `spec/support/mongoid.rb`

```ruby
RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
end
```

If you aren't using rails then you don't have to specify the type.
If you want to know why visit [the rspec documentation](https://relishapp.com/rspec/rspec-rails/docs/directory-structure).

## Matchers

### Association Matchers

```ruby
RSpec.describe User do
  it { is_expected.to have_many(:articles).with_foreign_key(:author_id).ordered_by(:title) }

  it { is_expected.to have_one(:record) }
  #can verify autobuild is set to true
  it { is_expected.to have_one(:record).with_autobuild }

  it { is_expected.to have_many :comments }

  #can also specify with_dependent to test if :dependent => :destroy/:destroy_all/:delete is set
  it { is_expected.to have_many(:comments).with_dependent(:destroy) }
  #can verify autosave is set to true
  it { is_expected.to have_many(:comments).with_autosave }

  it { is_expected.to embed_one :profile }

  it { is_expected.to have_and_belong_to_many(:children) }
  it { is_expected.to have_and_belong_to_many(:children).of_type(User) }
end

RSpec.describe Profile do
  it { is_expected.to be_embedded_in(:user).as_inverse_of(:profile) }
end

RSpec.describe Article do
  it { is_expected.to belong_to(:author).of_type(User).as_inverse_of(:articles) }
  it { is_expected.to belong_to(:author).of_type(User).as_inverse_of(:articles).with_index }
  it { is_expected.to embed_many(:comments) }
end

RSpec.describe Comment do
  it { is_expected.to be_embedded_in(:article).as_inverse_of(:comments) }
  it { is_expected.to belong_to(:user).as_inverse_of(:comments) }
end

RSpec.describe Record do
  it { is_expected.to belong_to(:user).as_inverse_of(:record) }
end

RSpec.describe Site do
  it { is_expected.to have_many(:users).as_inverse_of(:site).ordered_by(:email.asc).with_counter_cache }
end
```

### Mass Assignment Matcher

```ruby
RSpec.describe User do
  it { is_expected.to allow_mass_assignment_of(:login) }
  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:age) }
  it { is_expected.to allow_mass_assignment_of(:password) }
  it { is_expected.to allow_mass_assignment_of(:password) }
  it { is_expected.to allow_mass_assignment_of(:role).as(:admin) }

  it { is_expected.not_to allow_mass_assignment_of(:role) }
end
```

### Validation Matchers

```ruby
RSpec.describe Site do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end

RSpec.describe User do
  it { is_expected.to validate_presence_of(:login) }
  it { is_expected.to validate_uniqueness_of(:login).scoped_to(:site) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message("is already taken") }
  it { is_expected.to validate_format_of(:login).to_allow("valid_login").not_to_allow("invalid login") }
  it { is_expected.to validate_associated(:profile) }
  it { is_expected.to validate_exclusion_of(:login).to_not_allow("super", "index", "edit") }
  it { is_expected.to validate_inclusion_of(:role).to_allow("admin", "member") }
  it { is_expected.to validate_confirmation_of(:email) }
  it { is_expected.to validate_presence_of(:age).on(:create, :update) }
  it { is_expected.to validate_numericality_of(:age).on(:create, :update) }
  it { is_expected.to validate_inclusion_of(:age).to_allow(23..42).on([:create, :update]) }
  it { is_expected.to validate_presence_of(:password).on(:create) }
  it { is_expected.to validate_presence_of(:provider_uid).on(:create) }
  it { is_expected.to validate_inclusion_of(:locale).to_allow([:en, :ru]) }
end

RSpec.describe Article do
  it { is_expected.to validate_length_of(:title).within(8..16) }
end

RSpec.describe Profile do
  it { is_expected.to validate_numericality_of(:age).greater_than(0) }
end

RSpec.describe MovieArticle do
  it { is_expected.to validate_numericality_of(:rating).to_allow(:greater_than => 0).less_than_or_equal_to(5) }
  it { is_expected.to validate_numericality_of(:classification).to_allow(:even => true, :only_integer => true, :nil => false) }
end

RSpec.describe Person do
   # in order to be able to use the custom_validate matcher, the custom validator class (in this case SsnValidator)
   # should redefine the kind method to return :custom, i.e. "def self.kind() :custom end"
  it { is_expected.to custom_validate(:ssn).with_validator(SsnValidator) }
end
```

### Accepts Nested Attributes Matcher

```ruby
RSpec.describe User do
  it { is_expected.to accept_nested_attributes_for(:articles) }
  it { is_expected.to accept_nested_attributes_for(:comments) }
end

RSpec.describe Article do
  it { is_expected.to accept_nested_attributes_for(:permalink) }
end
```

### Index Matcher

```ruby
RSpec.describe Article do
  it { is_expected.to have_index_for(published: 1) }
  it { is_expected.to have_index_for(title: 1).with_options(unique: true, background: true) }
end

RSpec.describe Profile do
  it { is_expected.to have_index_for(first_name: 1, last_name: 1) }
end

Rspec.describe Log do
  it { is_expected.to have_index_for(created_at: 1).with_options(bucket_size: 100, expire_after_seconds: 3600) }
end
```

### Others

```ruby
RSpec.describe User do
  it { is_expected.to have_fields(:email, :login) }
  it { is_expected.to have_field(:s).with_alias(:status) }
  it { is_expected.to have_fields(:birthdate, :registered_at).of_type(DateTime) }

  # if you're declaring 'include Mongoid::Timestamps'
  # or any of 'include Mongoid::Timestamps::Created' and 'Mongoid::Timestamps::Updated'
  it { is_expected.to be_timestamped_document }
  it { is_expected.to be_timestamped_document.with(:created) }
  it { is_expected.not_to be_timestamped_document.with(:updated) }

  it { is_expected.to be_versioned_document } # if you're declaring `include Mongoid::Versioning`
  it { is_expected.to be_paranoid_document } # if you're declaring `include Mongoid::Paranoia`
  it { is_expected.to be_multiparameted_document } # if you're declaring `include Mongoid::MultiParameterAttributes`
end

RSpec.describe Log do
  it { is_expected.to be_stored_in :logs }
  it { is_expected.to be_dynamic_document }
end

RSpec.describe Article do
  it { is_expected.to have_field(:published).of_type(Boolean).with_default_value_of(false) }
  it { is_expected.to have_field(:allow_comments).of_type(Boolean).with_default_value_of(true) }
  it { is_expected.not_to have_field(:allow_comments).of_type(Boolean).with_default_value_of(false) }
  it { is_expected.not_to have_field(:number_of_comments).of_type(Integer).with_default_value_of(1) }
end
```

## Known issues

accept_nested_attributes_for matcher must test options [issue 91](https://github.com/mongoid-rspec/mongoid-rspec/issues/91).

## Acknowledgement

Thanks to [Durran Jordan][durran] for providing the changes necessary to make
this compatible with mongoid 2.0.0.rc, and for other [contributors](https://github.com/mongoid-rspec/mongoid-rspec/contributors)
to this project.

[mongoid-rspec]: https://github.com/mongoid-rspec/mongoid-rspec "A collection of RSpec-compatible matchers that help to test Mongoid documents."

[durran]: https://github.com/durran
[mongoid2]: https://rubygems.org/gems/mongoid-rspec/versions/1.4.5
[mongoid3]: https://rubygems.org/gems/mongoid-rspec/versions/1.13.0
[mongoid4]: https://rubygems.org/gems/mongoid-rspec/versions/2.1.0
[mongoid5]: https://rubygems.org/gems/mongoid-rspec/versions/3.1.0

[travis_badge]: http://img.shields.io/travis/mongoid-rspec/mongoid-rspec.svg?style=flat
[travis]: https://travis-ci.org/mongoid-rspec/mongoid-rspec

[rubygems_badge]: http://img.shields.io/gem/v/mongoid-rspec.svg?style=flat
[rubygems]: http://rubygems.org/gems/mongoid-rspec

[codeclimate_badge]: http://img.shields.io/codeclimate/github/mongoid-rspec/mongoid-rspec.svg?style=flat
[codeclimate]: https://codeclimate.com/github/mongoid-rspec/mongoid-rspec
