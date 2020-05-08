# [mongoid-rspec](https://github.com/mongoid/mongoid-rspec "A collection of RSpec-compatible matchers that help to test Mongoid documents.")

[![Build Status](https://travis-ci.org/mongoid/mongoid-rspec.svg?branch=master)](https://travis-ci.org/mongoid/mongoid-rspec)
[![Gem Version](https://badge.fury.io/rb/mongoid-rspec.svg)](https://badge.fury.io/rb/mongoid-rspec)

The mongoid-rspec library provides a collection of RSpec-compatible matchers that help to test Mongoid documents.

## Installation

Drop this line into your Gemfile:

```ruby
group :test do
  gem 'mongoid-rspec'
end

```

## Compatibility

This gem is compatible with Mongoid 3, 4, 5, 6 and 7.

## Configuration

### Rails

Add to your `rails_helper.rb` file

```ruby
require 'mongoid-rspec'

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
end
```

### Other

Add to your `spec_helper.rb` file.

```ruby
require 'mongoid-rspec'

RSpec.configure do |config|
  config.include Mongoid::Matchers
end
```

## Matchers

### be_mongoid_document

```ruby
class Post
  include Mongoid::Document
end

RSpec.describe Post, type: :model do
  it { is_expected.to be_mongoid_document }
end
```

### be_dynamic_document

```ruby
class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
end

RSpec.describe User, type: :model do
  it { is_expected.to be_dynamic_document }
end
```

### have_timestamps

With full timestamps.

```ruby
class Log
  include Mongoid::Document
  include Mongoid::Timestamps
end

RSpec.describe Log, type: :model do
  it { is_expected.to have_timestamps }
end
```

With short timestamps.

```ruby
class User
  include Mongoid::Document
  include Mongoid::Timestamps::Short
end

RSpec.describe User, type: :model do
  it { is_expected.to have_timestamps.shortened }
end
```

With only creating or updating timestamps.

```ruby
class Admin
  include Mongoid::Document
  include Mongoid::Timestamps::Create
  include Mongoid::Timestamps::Update
end

RSpec.describe Admin, type: :model do
  it { is_expected.to have_timestamps.for(:creating) }
  it { is_expected.to have_timestamps.for(:updating) }
end
```

With short creating or updating timestamps.

```ruby
class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Create::Short
end

RSpec.describe Short, type: :model do
  it { is_expected.to have_timestamps.for(:creating).shortened }
end
```

### be_stored_in

```ruby
class Post
  include Mongoid::Document

  store_in database: 'db1', collection: 'messages', client: 'secondary'
end

RSpec.describe Post, type: :model do
  it { is_expected.to be_stored_in(database: 'db1', collection: 'messages', client: 'secondary') }
end
```

It checks only those options, that you specify. For instance, test in example below will pass, even though expectation contains only `database` option.

```ruby
class Comment
  include Mongoid::Document

  store_in database: 'db2', collection: 'messages'
end

RSpec.describe Comment, type: :model do
  it { is_expected.to be_stored_in(database: 'db2') }
end
```

It works fine with lambdas and procs.

```ruby
class User
  include Mongoid::Document

  store_in database: ->{ Thread.current[:database] }
end

RSpec.describe Post, type: :model do
  it do
    Thread.current[:database] = 'db3'
    is_expected.to be_stored_in(database: 'db3')

    Thread.current[:database] = 'db4'
    is_expected.to be_stored_in(database: 'db4')
  end
end
```

### have_index_for

```ruby
class Article
  index({ title: 1 }, { unique: true, background: true, drop_dups: true })
  index({ title: 1, created_at: -1 })
  index({ category: 1 })
end

RSpec.describe Article, type: :model do
  it do
    is_expected
      .to have_index_for(title: 1)
      .with_options(unique: true, background: true, drop_dups: true)
  end
  it { is_expected.to have_index_for(title: 1, created_at: -1) }
  it { is_expected.to have_index_for(category: 1) }
end
```

### Field Matchers

```ruby
RSpec.describe Article do
  it { is_expected.to have_field(:published).of_type(Boolean).with_default_value_of(false) }
  it { is_expected.to have_field(:allow_comments).of_type(Boolean).with_default_value_of(true) }
  it { is_expected.not_to have_field(:allow_comments).of_type(Boolean).with_default_value_of(false) }
  it { is_expected.not_to have_field(:number_of_comments).of_type(Integer).with_default_value_of(1) }
end

RSpec.describe User do
  it { is_expected.to have_fields(:email, :login) }
  it { is_expected.to have_field(:s).with_alias(:status) }
  it { is_expected.to have_fields(:birthdate, :registered_at).of_type(DateTime) }
end
```

### Association Matchers

```ruby
RSpec.describe User do
  it { is_expected.to have_many(:articles).with_foreign_key(:author_id).ordered_by(:title) }

  it { is_expected.to have_one(:record) }

  # can verify autobuild is set to true
  it { is_expected.to have_one(:record).with_autobuild }

  it { is_expected.to have_many :comments }

  # can also specify with_dependent to test if :dependent => :destroy/:destroy_all/:delete is set
  it { is_expected.to have_many(:comments).with_dependent(:destroy) }

  # can verify autosave is set to true
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

RSpec.describe Message do
  it { is_expected.to belong_to(:user).with_optional }
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
  it { is_expected.to validate_absence_of(:deletion_date) }
end

RSpec.describe Visitor do
  it { is_expected.to validate_length_of(:name).with_maximum(160).with_minimum(1) }
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

## Contributing

You're encouraged to contribute to this library. See [CONTRIBUTING](CONTRIBUTING.md) for details.

## Copyright and License

Copyright (c) 2009-2018 Evan Sagge and Contributors.

MIT License. See [LICENSE](LICENSE) for details.
